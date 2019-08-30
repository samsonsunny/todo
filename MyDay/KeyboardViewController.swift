//
//  KeyboardViewController.swift
//  MyDay
//
//  Created by Sam on 8/23/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

protocol KeyboardNotificationHandler: class {
	func addKeyboardNotifications()
	func removeKeyboardNotifications()
	func keyBoardWillHide(_ notification: NSNotification)
	func keyBoardWillShow(_ notification: NSNotification)
}

class KeyboardViewController: UIViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeKeyboardNotifications()
	}
}

extension UIViewController: KeyboardNotificationHandler {
	
	@objc func keyBoardWillHide(_ notification: NSNotification) { }
	
	@objc func keyBoardWillShow(_ notification: NSNotification) { }
	
	func addKeyboardNotifications() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyBoardWillHide),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyBoardWillShow),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
	}
	
	func removeKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillHideNotification,
												  object: nil)
		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillShowNotification,
												  object: nil)
	}
}
