//
//  SignInViewController.swift
//  MyDay
//
//  Created by Sam on 2/17/20.
//  Copyright © 2020 samsonsunny. All rights reserved.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import UIKit

class SignInViewController: UIViewController {
	// Unhashed nonce.
	fileprivate var currentNonce: String?
	
	@IBOutlet weak var appLogo: UIImageView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		appLogo.roundCorners(corners: .allCorners, radius: 15)
		activityIndicator.isHidden = true
		setupProviderLoginView()
	}
	
	/// - Tag: add_appleid_button
	func setupProviderLoginView() {
		let authorizationButton = ASAuthorizationAppleIDButton()
		authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
		stackView.addArrangedSubview(authorizationButton)
	}
	
	/// - Tag: perform_appleid_request
	@objc func handleAuthorizationAppleIDButtonPress() {
		startSignInWithAppleFlow()
	}
	
	func startSignInWithAppleFlow() {
		let nonce = Nonce.randomNonceString()
		currentNonce = nonce
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]
		request.nonce = Nonce.sha256(nonce)
		
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
}

extension SignInViewController: ASAuthorizationControllerDelegate {
	private func signin(with credential: OAuthCredential) {
		Auth.auth().signIn(with: credential) { (result, error) in
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.moveToTabBarView()
		}
	}
	
	private func saveUserInUserPreference(_ userIdentifier: String) {
		UserDefaults.standard.set(userIdentifier, forKey: appleUserIdentifierKey)
	}
	
	private func moveToTabBarView() {
		let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewControllerID")
		self.navigationController?.pushViewController(tabBar, animated: true)
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
			return
		}
		guard let nonce = currentNonce else {
//			fatalError("Invalid state: A login callback was received, but no login request was sent.")
			return
		}
		guard let appleIDToken = appleIDCredential.identityToken else {
//			print("Unable to fetch identity token")
			return
		}
		guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//			print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
			return
		}
		
		// Initialize a Firebase credential.
		let credential = OAuthProvider.credential(withProviderID: "apple.com",
												  idToken: idTokenString,
												  rawNonce: nonce)
		saveUserInUserPreference(appleIDCredential.user)
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		
		signin(with: credential)
	}
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
	/// - Tag: provide_presentation_anchor
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
}
