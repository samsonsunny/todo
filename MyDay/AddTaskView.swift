//
//  AddTaskView.swift
//  MyDay
//
//  Created by Sam on 9/26/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class AddTaskView: UIView {
	
	lazy var leadingButton: UIButton = {
		let _leadingButton = UIButton(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
	
		return _leadingButton
	}()
	
	lazy var textField: UITextField = {
		let _textField = UITextField(frame: CGRect(x: 60, y: 0, width: self.frame.width - 60, height: self.frame.height))
		_textField.placeholder = "Add Task"
		return _textField
	}()
	
	override func draw(_ rect: CGRect) {
		print("draw")
		leadingButton.setTitle("Hello", for: .normal)
	}
	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		initialise()
//	}
//
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//		initialise()
//		fatalError("init(coder:) has not been implemented")
//	}
	
	func initialise() {
		self.leadingButton.setImage(UIImage(systemName: "plus"), for: .normal)
//		self.leadingButton..setImage(UIImage(systemName: "plus"), for: .normal)
	}
}
