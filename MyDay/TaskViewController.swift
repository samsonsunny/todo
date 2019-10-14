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
	
	@IBOutlet weak var daySegmentedView: UISegmentedControl!
	
	@IBOutlet weak var addTaskView: AddTaskView!
	
	@IBOutlet weak var pageContainer: UIView!
	
	var selectedDateFromCalendar: Date = Date().dateAtStartOf(.day)
	
	private var selectedDateFromSegementedView: Date {
		switch activeSegmentIndex {
		case 0:
			return selectedDateFromCalendar.dateByAdding(-1, .day).date
		case 2:
			return selectedDateFromCalendar.dateByAdding(1, .day).date
		default:
			return selectedDateFromCalendar
		}
	}
		
	// Used just to utilise the animation of view controller presentation.
	private let paginator = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
	
	private var activeSegmentIndex: Int = 1 {
		didSet {
			if let todoView = todoListView {
				todoView.activeDate = selectedDateFromSegementedView
				self.addViewController(forPagination: todoView, direction: .forward, animated: true)
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
		self.addPaginator()
		self.addViewController(forPagination: todoListView, direction: .forward, animated: false)
	}
	
	@IBAction func dayChanged(_ sender: UISegmentedControl) {
		activeSegmentIndex = sender.selectedSegmentIndex
	}
	
	@objc override func keyBoardWillHide(_ notification: NSNotification) {
		addTaskView.adjustViewBasedOnKeyboard(visibility: false, notification: notification)
	}
	
	@objc override func keyBoardWillShow(_ notification: NSNotification) {
		addTaskView.adjustViewBasedOnKeyboard(visibility: true, notification: notification)
	}
	
	private func addPaginator() {
		self.addChild(paginator)
		paginator.view.translatesAutoresizingMaskIntoConstraints = false
		pageContainer.addSubview(paginator.view)

		NSLayoutConstraint.activate([
			paginator.view.leadingAnchor.constraint(equalTo: pageContainer.leadingAnchor),
			paginator.view.trailingAnchor.constraint(equalTo: pageContainer.trailingAnchor),
			paginator.view.topAnchor.constraint(equalTo: pageContainer.topAnchor),
			paginator.view.bottomAnchor.constraint(equalTo: pageContainer.bottomAnchor)
		])
		paginator.didMove(toParent: self)
	}
	
	private func addViewController(forPagination taskListView: TodoListViewController?, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
		if let viewController = taskListView {
			paginator.setViewControllers([viewController],
										 direction: direction,
										 animated: animated,
										 completion: nil)
		}
	}
	
	func saveTodo(_ todo: Todo, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) {
		let task = Task(context: context)
		task.setTask(with: todo)
		context.mr_saveToPersistentStore() 
	}
}

extension TaskViewController: AddTasker {
	func addTask(with text: String) {
		let todo = Todo(title: text, date: selectedDateFromSegementedView)
		saveTodo(todo)
	}
}
