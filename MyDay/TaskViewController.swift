//
//  TaskViewController.swift
//  MyDay
//
//  Created by Sam on 9/17/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import MagicalRecord

class TaskViewController: KeyboardViewController {
		
	@IBOutlet weak var addTaskView: AddTaskView!
	
	var dayPaginator: UIPageViewController?
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			if self.isViewLoaded {
				self.updatePageTitle(from: activeDate)
			}
		}
	}
	
	private var todoListView: TodoListViewController? {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyBoard.instantiateViewController(withIdentifier: "TodoListViewControllerID")
		return vc as? TodoListViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.addTaskView.tasker = self
		self.setTodoListViewController(todoListView, direction: .forward, animated: false)

		self.updatePageTitle(from: activeDate)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueID.dayPagination.rawValue {
			self.dayPaginator = segue.destination as? UIPageViewController
		}
	}
	
	override func keyBoardWillHide(_ notification: NSNotification) {
		addTaskView.adjustViewBasedOnKeyboard(visibility: false, notification: notification)
	}
	
	override func keyBoardWillShow(_ notification: NSNotification) {
		addTaskView.adjustViewBasedOnKeyboard(visibility: true, notification: notification)
	}
	
	private func updatePageTitle(from date: Date) {
		if date.isToday {
			self.title = "Today"
		} else if date.isTomorrow {
			self.title = "Tomorrow"
		} else if date.isYesterday {
			self.title = "Yesterday"
		} else {
			self.title = date.toFormat("MMMM d")
		}
	}
	
	private func setTodoListViewController(_ vc: TodoListViewController?, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
		if let todoView = vc {
			todoView.activeDate = activeDate
			todoView.delegate = self
			self.addViewController(forPagination: todoView, direction: direction, animated: animated)
		}
	}
	
	private func addViewController(forPagination taskListView: TodoListViewController, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
		
		dayPaginator?.setViewControllers([taskListView],
									 direction: direction,
									 animated: animated,
									 completion: nil)
	}
	
	func saveTodo(_ todo: Todo, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) {
		let task = Task(context: context)
		task.setTask(with: todo)
		context.mr_saveToPersistentStore { (bool, nil) in
			self.refetchTaskAndScrollToLastRow()
		}
	}
	
	func refetchTaskAndScrollToLastRow() {
		(dayPaginator?.viewControllers?.first as? TodoListViewController)?.refreshView(scrollToLastRow: true)
	}
}

extension TaskViewController: AddTasker {
	func addTask(with text: String) {
		let todo = Todo(title: text, date: activeDate)
		saveTodo(todo)
	}
	
	func showNextPage() {
		activeDate = activeDate.dateByAdding(1, .day).date
		setTodoListViewController(todoListView, direction: .forward)
	}
	
	func showPrevPage() {
		activeDate = activeDate.dateByAdding(-1, .day).date
		setTodoListViewController(todoListView, direction: .reverse)
	}
}
