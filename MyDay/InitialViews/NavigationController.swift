//
//  NavigationController.swift
//  MyDay
//
//  Created by Sam on 10/25/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class NavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		guard let uid = UserDefaults.standard.string(forKey: appleUserIdentifierKey) else {
//			setLoginVC()
//			return
//		}
//		checkUserStatus(userID: uid)
	}
	
	func logout() {
		do {
			try Auth.auth().signOut()
		} catch {
			
		}
		setLoginVC() 
	}
	
//	private func checkUserStatus(userID: String) {
//		let appleIDProvider = ASAuthorizationAppleIDProvider()
//		appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
//			switch credentialState {
//			case .authorized:
//				DispatchQueue.main.async {
//					self.setTabBarVC()
//				}
//			case .revoked, .notFound, .transferred:
//				DispatchQueue.main.async {
//					self.setLoginVC()
//				}
//			@unknown default: fatalError()
//			}
//		}
//	}
	
	private func setLoginVC() {
		let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
			identifier: "SignInViewControllerID"
		)
		self.setViewControllers([loginVC], animated: false)
	}
	
//	private func setTabBarVC() {
//		let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewControllerID")
//		self.setViewControllers([tabBar], animated: false)
//	}
}
