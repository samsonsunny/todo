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
	
	var selectedDateFromCalendar: Date = Date().dateAtStartOf(.day) {
		didSet {
			self.activeDates = [
				selectedDateFromCalendar.dateByAdding(-1, .day).date,
				selectedDateFromCalendar,
				selectedDateFromCalendar.dateByAdding(1, .day).date
			]
		}
	}
	
	private var activeDates: [Date] = [
		Date().dateAtStartOf(.day).dateByAdding(-1, .day).date,
		Date().dateAtStartOf(.day),
		Date().dateAtStartOf(.day).dateByAdding(1, .day).date
	]
	
	private var selectedDateFromSegementedView: Date {
		return activeDates[activeSegmentIndex]
	}
	
	// Used just to utilise the animation of view controller presentation.
	private let paginator = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
	
	private var activeSegmentIndex: Int = 1 {
		didSet {
			setTodoListViewController(todoListView)
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
		self.setTodoListViewController(todoListView)
		self.updateSegmentsTitle()
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
	
	private func updateSegmentsTitle() {
		
		if selectedDateFromCalendar.isToday {
			daySegmentedView.setTitle("Yesterday", forSegmentAt: 0)
			daySegmentedView.setTitle("Today", forSegmentAt: 1)
			daySegmentedView.setTitle("Tomorrow", forSegmentAt: 2)
		} else {
			let prevDay = selectedDateFromCalendar.dateByAdding(-1, .day).date
			let nextDay = selectedDateFromCalendar.dateByAdding(1, .day).date
			
			daySegmentedView.setTitle(prevDay.toFormat("MMM d"), forSegmentAt: 0)
			daySegmentedView.setTitle(selectedDateFromCalendar.toFormat("MMM d"), forSegmentAt: 1)
			daySegmentedView.setTitle(nextDay.toFormat("MMM d"), forSegmentAt: 2)
		}
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
	
	private func setTodoListViewController(_ vc: TodoListViewController?) {
		if let todoView = vc {
			todoView.activeDate = selectedDateFromSegementedView
			todoView.delegate = self
			self.addViewController(forPagination: todoView, direction: .forward, animated: false)
		}
	}
	
	private func addViewController(forPagination taskListView: TodoListViewController, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
		
		paginator.setViewControllers([taskListView],
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
	
	//	func refetchTasks() {
	//		tasks = Task.getTasks(for: activeDate)
	//		DispatchQueue.main.async {
	//			self.todoListView.reloadData()
	//			self.toggleEditButton()
	//			self.toggleAddTaskButton()
	//		}
	//	}
	
	func refetchTaskAndScrollToLastRow() {
		(paginator.viewControllers?.first as? TodoListViewController)?.refreshView(scrollToLastRow: true)
	}
}

extension TaskViewController: AddTasker {
	func addTask(with text: String) {
		let todo = Todo(title: text, date: selectedDateFromSegementedView)
		saveTodo(todo)
	}
}

extension TaskViewController: TodoListDelegate {
	func listViewTapped() {
		if addTaskView.addTaskTextField.isFirstResponder {
			addTaskView.removeFoucsFromAddTaskTextField()
		} else {
			addTaskView.bringFocusToAddTaskTextField()
		}
	}
	
	func listViewDragged(_ scrollView: UIScrollView) {
		if addTaskView.addTaskTextField.isFirstResponder {
			addTaskView.removeFoucsFromAddTaskTextField()
		}
	}
	
	func deleteTask(_ task: Task) {
		task.mr_deleteEntity(in: .mr_default())
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
			(self.paginator.viewControllers?.first as? TodoListViewController)?.reloadTasks()
		}
	}
	
	func updateTask(_ task: Task, with todo: Todo) {
		task.setTask(with: todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
			(self.paginator.viewControllers?.first as? TodoListViewController)?.reloadTasks()
		}
	}
}

