//
//  CreateTaskView.swift
//  MyDay
//
//  Created by Sam on 12/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class CreateTaskView: TopCornerRoundedView {
	
	var textField: UITextField = UITextField()
	var saveButton: UIButton = UIButton()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		textField.frame = CGRect(x: 12.0, y: 10.0, width: frame.width, height: 50)
		textField.placeholder = "Add Task"
		saveButton.frame = CGRect(x: frame.width - 60.0, y: 50.0, width: 40.0, height: 50.0)
		saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		saveButton.setTitle("Save", for: .normal)
		saveButton.setTitleColor(UIColor.systemIndigo, for: .normal)
		self.addSubview(textField)
		self.addSubview(saveButton)
		self.backgroundColor = UIColor.systemGray6
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
