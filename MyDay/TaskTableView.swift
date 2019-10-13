//
//  TaskTableView.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TaskTableView: UITableView {
	
	var tasks: [Task] = [] {
		didSet {
			print("tasks")
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.delegate = self
		self.dataSource = self
		self.showsVerticalScrollIndicator = false
	}
}

extension TaskTableView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell
				
		let todo = Todo(title: "Hello", date: Date())
		
		cell?.updateCell(with: todo)
		
		
		//(task: tasks[indexPath.row])
				
		//		if tableView.isEditing {
//					cell?.updateCell(with: todo)
		//		} else {
//					cell?.updateCell(with: todo, delegate: self, indexPath: indexPath)
		//		}
										
		return cell ?? UITableViewCell()
	}
	
}

/*

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		removeFoucsFromAddTaskField()
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell
		let todo = Todo(task: tasks[indexPath.row])
		
//		if tableView.isEditing {
//			cell?.updateCell(with: todo)
//		} else {
			cell?.updateCell(with: todo, delegate: self, indexPath: indexPath)
//		}
								
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
			self.deleteTodo(inRow: indexPath.row)
//			self.promptDeleteAlert(for: indexPath)
		}
		deleteAction.backgroundColor = UIColor.red
		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		removeFoucsFromAddTaskField()
	}
}


*/
