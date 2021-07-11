////
////  TaskTableView.swift
////  MyDay
////
////  Created by Sam on 10/12/19.
////  Copyright © 2019 samsonsunny. All rights reserved.
////
//
//import UIKit
//
//protocol TaskTableViewDelegate: TodoCellDelegate {
//	func tableViewDidDragged(_ scrollView: UIScrollView)
//	func deleteTask(atRow row: Int)
//}
//
//class TaskTableView: UITableView {
//	
//	var tasks: [Task] = [] {
//		didSet {
////			DispatchQueue.main.async {
////				self.reloadData()
////			}
//		}
//	}
//	
//	var taskPerDate: [Int: [Task]] = [:] {
//		didSet {
//			DispatchQueue.main.async {
//				self.reloadData()
//			}
//		}
//	}
//	
//	weak var helper: TaskTableViewDelegate?
//	
//	override func awakeFromNib() {
//		super.awakeFromNib()
//		self.delegate = self
//		self.dataSource = self
//		self.showsVerticalScrollIndicator = false
//	}
//	
//	var isEmpty: Bool {
//		return self.numberOfRows(inSection: 0) == 0
//	}
//}
//
//extension TaskTableView: UITableViewDelegate, UITableViewDataSource {
//	
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return taskPerDate.keys.count
//	}
//	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return taskPerDate[section]?.count ?? 0 
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		
//		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell
////		let todo = Todo(task: tasks[indexPath.row])
//		let todo = Todo(task: taskPerDate[indexPath.section]![indexPath.row]) 
////		tasks[indexPath.row])
//		
//		cell?.updateCell(with: todo, delegate: helper, indexPath: indexPath)
//				
//		return cell ?? UITableViewCell()
//	}
//	
//	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//		
//		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
//			self.helper?.deleteTask(atRow: indexPath.row)
//		}
//		deleteAction.backgroundColor = UIColor.red
//		return [deleteAction]
//	}
//	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let view = UIView()
//		view.backgroundColor = UIColor.yellow
//		return view
//	}
//	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		helper?.tableViewDidDragged(tableView)
//	}
//	
//	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		helper?.tableViewDidDragged(scrollView)
//	}
//}
