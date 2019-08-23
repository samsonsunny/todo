//
//  TodoCell.swift
//  MyDay
//
//  Created by Sam on 8/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit 

class TodoCell: UITableViewCell {
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var circleButton: UIButton!
	
	var activeDate: Date = Date().dateAtStartOf(.day)
	
	var todo: Todo?
	
	var isCompleted: Bool = false {
		didSet {
			setCompletedTick()
			setStrikeThrough()
		}
	}
	
	private func setCompletedTick() {
		DispatchQueue.main.async {
			if self.isCompleted {
				self.circleButton.setImage(UIImage(named: "tick-circle"), for: .normal)
			} else {
				self.circleButton.setImage(UIImage(named: "grey-circle"), for: .normal)
			}
		}
	}
	
	private func setStrikeThrough() {
		DispatchQueue.main.async {
			let attributeString =  NSMutableAttributedString(string: self.title.text ?? "")
			
			if self.isCompleted {
				let textRange = NSMakeRange(0, attributeString.length)
				attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: textRange)
				attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: textRange)
				self.title.textColor = UIColor.darkGray
			} else {
				self.title.textColor = UIColor.black
			}
			self.title.attributedText = attributeString
		}
	}
	
	@IBAction func completedButtonTapped(_ sender: Any) {
		isCompleted = !isCompleted
		
		if let data = UserDefaults.standard.value(forKey:activeDate.toString()) as? Data {
			
			if var todos = try? PropertyListDecoder().decode(Array<Todo>.self, from: data) {
				
				let index = todos.firstIndex(of: todo!)
				
				todos.remove(at: index!)
				
				todo?.isCompleted = self.isCompleted
				
				todos.insert(todo!, at: index!)
				
				UserDefaults.standard.set(try? PropertyListEncoder().encode(todos), forKey:activeDate.toString())
				
			}
		}
	}
	
	func updateCell(with todo: Todo, activeDate: Date) {
		self.title.text = todo.title
		self.isCompleted = todo.isCompleted
		self.activeDate = activeDate
		
		self.todo = todo
	}
}
