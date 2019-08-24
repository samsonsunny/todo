//
//  TodoCell.swift
//  MyDay
//
//  Created by Sam on 8/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

protocol TodoCellDelegate: class {
	func didTodoCompleted(_ todo: Todo?, indexPath: IndexPath?)
}

class TodoCell: UITableViewCell {
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var circleButton: UIButton!
	
	private let tickCircle = UIImage(named: "tick-circle")
	private let greyCircle = UIImage(named: "grey-circle")
	private var indexPath: IndexPath?
	private var delegate: TodoCellDelegate?
	private var todo: Todo? {
		didSet {
			updateTodoCell(todo)
		}
	}
	
	@IBAction func completedButtonTapped(_ sender: Any) {
		
		guard let todoStatus = todo?.isCompleted else {
			return
		}
		todo?.isCompleted = !todoStatus
		delegate?.didTodoCompleted(todo, indexPath: indexPath)
	}
	
	func updateCell(with todo: Todo, delegate: TodoCellDelegate, indexPath: IndexPath) {
		self.todo = todo
		self.delegate = delegate
		self.indexPath = indexPath
	}
	
	private func updateTodoCell(_ todo: Todo?) {
		if let _todo = todo {
			setCircleButtonImage(forStatus: _todo.isCompleted)
			setTodoTitle(_todo.title, forStatus: _todo.isCompleted)
		}
	}
	
	private func setCircleButtonImage(forStatus isCompleted: Bool) {
		let image = isCompleted ? tickCircle: greyCircle
		circleButton.setImage(image, for: .normal)
	}
	
	private func setTodoTitle(_ text: String, forStatus isCompleted: Bool) {
		let titleText = NSMutableAttributedString(string: text)
		if isCompleted {
			titleText.applyStrikeThroughStyle()
			title.textColor = UIColor.lightGray
		} else {
			title.textColor = UIColor.black
		}
		title.attributedText = titleText
	}
}

extension NSMutableAttributedString {
	func applyStrikeThroughStyle() {
		
		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.strikethroughStyle: 1,
			NSAttributedString.Key.strikethroughColor: UIColor.lightGray]
		
		self.addAttributes(attributes, range: NSMakeRange(0, self.length))
	}
}
