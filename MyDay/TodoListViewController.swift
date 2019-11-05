//
//  TodoListViewController.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

protocol TodoListDelegate: class {
	func listViewTapped()
	func listViewDragged(_ scrollView: UIScrollView)
	func deleteTask(_ task: Task)
	func updateTask(_ task: Task, with todo: Todo)
}

class TodoListViewController: UIViewController {
	
	@IBOutlet weak var todoListView: TaskTableView!
	
	weak var delegate: TodoListDelegate?
	
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			self.reloadTasks()
		}
	}
	
	private lazy var tapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(listViewTapped))
		gesture.cancelsTouchesInView = false
		gesture.delegate = self
		return gesture
	}()
	
	private var tasks: [Task] = [] {
		didSet {
			if isViewLoaded {
				todoListView.tasks = tasks
			}
		}
	}
	
	private var taskPerDate: [Int: [Task]] = [:] {
		didSet {
			if isViewLoaded {
				todoListView.taskPerDate = taskPerDate
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		todoListView.tasks = tasks
		todoListView.taskPerDate = taskPerDate
		todoListView.addGestureRecognizer(tapGesture)
		todoListView.helper = self
    }
	
	func reloadTasks() {
		self.tasks = Task.getTasks(for: activeDate)
		
//		let x = Task.getTasks(for: activeDate)
//		let y = Task.getTasks(for: activeDate.dateByAdding(1, .day).date)
//		let z = Task.getTasks(for: activeDate.dateByAdding(2, .day).date)
		
		self.taskPerDate = [
			0: Task.getTasks(for: activeDate),
			1: Task.getTasks(for: activeDate.dateByAdding(1, .day).date),
			2: Task.getTasks(for: activeDate.dateByAdding(2, .day).date)
		]
	}
	
	func refreshView(scrollToLastRow: Bool = false) {
		
		self.reloadTasks()
		
		guard !self.todoListView.isEmpty else {
			return
		}
				
		let lastRow = self.todoListView.numberOfRows(inSection: 0) - 1
		let lastIndexPath = IndexPath(row: lastRow, section: 0)

		self.todoListView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
	}
}

extension TodoListViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let location = touch.location(in: todoListView)
		if todoListView.indexPathForRow(at: location) != nil {
			return false
		}
		return true
	}
	
	@objc func listViewTapped() {
		delegate?.listViewTapped()
	}
}

extension TodoListViewController: TaskTableViewDelegate {
	
	func didTodoCompleted(_ todo: Todo?, indexPath: IndexPath?) {
		guard let _todo = todo, let _indexPath = indexPath else {
			return
		}
		let task = tasks[_indexPath.row]		
		delegate?.updateTask(task, with: _todo)
	}
	
	func didMoreMenuTapped(on indexPath: IndexPath?) {
		
	}
	
	func deleteTask(atRow row: Int) {
		delegate?.deleteTask(self.tasks[row])
	}
	
	func tableViewDidDragged(_ scrollView: UIScrollView) {
		delegate?.listViewDragged(scrollView)
	}
}
