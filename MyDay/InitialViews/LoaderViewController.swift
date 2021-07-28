//
//  LoaderViewController.swift
//  MyDay
//
//  Created by Sam on 11/30/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

let appleUserIdentifierKey: String = "appleUserIdentifierKey"

class LoaderViewController: UIViewController {

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var tasksCollectionRef: CollectionReference?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		activityIndicator.isHidden = true 
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		guard let uid = UserDefaults.standard.string(forKey: appleUserIdentifierKey) else {
			setLoginVC()
			return
		}
		checkUserStatus(userID: uid)
    }
	
	private func checkUserStatus(userID: String) {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
			switch credentialState {
			case .authorized:
				DispatchQueue.main.async {
					self.setTabBarVC()
				}
			case .revoked, .notFound, .transferred:
				DispatchQueue.main.async {
					self.setLoginVC()
				}
			@unknown default: fatalError()
			}
		}
	}
	
	private func setLoginVC() {
		let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
			identifier: "SignInViewControllerID"
		)
		self.navigationController?.setViewControllers([loginVC], animated: true)
	}
	
	private func setTabBarVC() {
		let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
			identifier: "TabBarViewControllerID"
		)
		self.navigationController?.setViewControllers([tabBar], animated: true)
	}
}
