//
//  AddTaskView.swift
//  MyDay
//
//  Created by Sam on 9/26/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class AddTaskView: UIView {
	
	@IBOutlet weak var leadingButton: UIButton!
	@IBOutlet weak var addTaskLabel: UILabel!
	@IBOutlet weak var addTaskTextField: UITextField!
	@IBOutlet weak var addTaskButton: UIButton!
	@IBOutlet weak var addTaskButtonHeightConstraint: NSLayoutConstraint!
	
	private let circleImage = UIImage(systemName: "circle")
	private let plusImage = UIImage(systemName: "plus")
	private let defaultViewHeight = CGFloat(60)
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func addTaskButtonTapped(_ sender: Any) {
		bringFocusToAddTaskTextField()
	}
	
	func adjustViewBasedOnKeyboard(visibility willShow: Bool, notification: NSNotification) {
		let height = getKeyboardHeight(from: notification.userInfo)
		adjustAddTaskView(height: height, keyboard: willShow)
	}
	
	private func bringFocusToAddTaskTextField() {
		hideAddTaskTextField(false)
		hideAddTaskButton(true)
		leadingButton.setImage(circleImage, for: .normal)
		addTaskTextField.becomeFirstResponder()
	}
	
	private func hideAddTaskTextField(_ hide: Bool) {
		addTaskTextField.isHidden = hide
	}
	
	private func hideAddTaskButton(_ hide: Bool) {
		addTaskLabel.isHidden = hide
		addTaskButton.isHidden = hide
	}
	
	private func getKeyboardHeight(from notificationPayload: [AnyHashable : Any]?) -> CGFloat {
		if let frame = notificationPayload?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
			return frame.size.height
		}
		return 0
	}
	
	private func adjustAddTaskView(height: CGFloat, keyboard isVisible: Bool) {
		addTaskButtonHeightConstraint.constant = isVisible ? height : defaultViewHeight
		UIView.animate(withDuration: 0.25) {
			self.layoutIfNeeded()
		}
	}
}
