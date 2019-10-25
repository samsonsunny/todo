//
//  AddTaskView.swift
//  MyDay
//
//  Created by Sam on 9/26/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

protocol AddTasker: class {
	func addTask(with text: String)
	func showNextPage()
	func showPrevPage()
}

class AddTaskView: UIView, UITextFieldDelegate {
	
	@IBOutlet weak var leadingButton: UIButton!
	@IBOutlet weak var addTaskLabel: UILabel!
	@IBOutlet weak var addTaskTextField: UITextField!
	@IBOutlet weak var addTaskButton: UIButton!
	@IBOutlet weak var addTaskButtonHeightConstraint: NSLayoutConstraint!
	
	private let circleImage = UIImage(systemName: "circle")
	private let plusImage = UIImage(systemName: "plus")
	private let defaultViewHeight = CGFloat(60)
	
	weak var tasker: AddTasker? 
	
	override func awakeFromNib() {
		super.awakeFromNib()
		addTaskTextField.delegate = self
	}
	
	@IBAction func addTaskButtonTapped(_ sender: Any) {
		bringFocusToAddTaskTextField()
	}
	
	func adjustViewBasedOnKeyboard(visibility willShow: Bool, notification: NSNotification) {
		let height = getKeyboardHeight(from: notification.userInfo)
		adjustAddTaskView(height: height, keyboard: willShow)
	}
	
	func bringFocusToAddTaskTextField() {
		
		self.setActiveViewMode()
		addTaskTextField.becomeFirstResponder()
	}
	
	func removeFoucsFromAddTaskTextField() {
		addTaskTextField.resignFirstResponder()
		UIView.animate(withDuration: 0.25, animations: {
			self.updateView()
		})
	}
	
	private func updateView() {
		if let todoText = addTaskTextField.text, todoText.isNotEmpty {
			self.setActiveViewMode()
		} else {
			self.setDefaultViewMode()
		}
	}
	
	private func setDefaultViewMode() {

		addTaskTextField.isHidden = true
		addTaskLabel.isHidden = false
		addTaskButton.isHidden = false
		leadingButton.setImage(plusImage, for: .normal)
	}
	
	private func setActiveViewMode() {
	
		addTaskTextField.isHidden = false
		addTaskLabel.isHidden = true
		addTaskButton.isHidden = true
		leadingButton.setImage(circleImage, for: .normal)
	}
	
	private func getKeyboardHeight(from notificationPayload: [AnyHashable : Any]?) -> CGFloat {
		if let frame = notificationPayload?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
			return frame.size.height
		}
		return 0
	}
	
	private func adjustAddTaskView(height: CGFloat, keyboard isVisible: Bool) {
		addTaskButtonHeightConstraint.constant = isVisible ? height + 30 : defaultViewHeight
		UIView.animate(withDuration: 0.25) {
			self.layoutIfNeeded()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, text.isNotEmpty else {
			removeFoucsFromAddTaskTextField()
			return true
		}
		tasker?.addTask(with: text)
		textField.clear()
		return true
	}
}
