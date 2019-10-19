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
	
	private var dayPaginator: UIPageViewController?
		
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
		self.setTodoListViewController(todoListView)
		self.updateSegmentsTitle()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "dayPaginationSegue" {
			self.dayPaginator = segue.destination as? UIPageViewController
		}
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
	
	private func setTodoListViewController(_ vc: TodoListViewController?) {
		if let todoView = vc {
			todoView.activeDate = selectedDateFromSegementedView
			todoView.delegate = self
			self.addViewController(forPagination: todoView, direction: .forward, animated: false)
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
			(self.dayPaginator?.viewControllers?.first as? TodoListViewController)?.reloadTasks()
		}
	}
	
	func updateTask(_ task: Task, with todo: Todo) {
		task.setTask(with: todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
			(self.dayPaginator?.viewControllers?.first as? TodoListViewController)?.reloadTasks()
		}
	}
}

