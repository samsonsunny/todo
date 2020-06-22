////
////  TaskViewController.swift
////  MyDay
////
////  Created by Sam on 9/17/19.
////  Copyright © 2019 samsonsunny. All rights reserved.
////
//
//import UIKit
//import SwiftDate
//import MagicalRecord
//
//class TaskViewController: KeyboardViewController {
//		
//	@IBOutlet weak var addTaskView: AddTaskView!
//	@IBOutlet weak var dateSliderView: DateSliderView!
//	
//	@IBOutlet weak var sliderHeaderLabel: UILabel!
//	
//	var dayPaginator: UIPageViewController?
//	
//	var activeDate: Date = Date().dateAtStartOf(.day) {
//		didSet {
//			if self.isViewLoaded {
//				
//				self.dateSliderView.selectedDate = activeDate
//				
//				if oldValue < activeDate {
//					setTodoListViewController(todoListView, direction: .forward)
//				} else if oldValue > activeDate {
//					setTodoListViewController(todoListView, direction: .reverse)
//				}
//			}
//		}
//	}
//	
//	private var todoListView: TodoListViewController? {
//		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//		let vc = storyBoard.instantiateViewController(withIdentifier: ViewController.todoList.id)
//		return vc as? TodoListViewController
//	}
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		self.navigationItem.hidesBackButton = true
//				
//		addTaskView.tasker = self
//		dateSliderView.helper = self
//		dateSliderView.selectedDate = activeDate
//		setTodoListViewController(todoListView, direction: .forward, animated: false)
//		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//			self.dateSliderView.scrollTo(date: self.activeDate, animated: false)
//		})
//		sliderHeaderLabel.text = "October"
//	}
//	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == SegueID.dayPagination.rawValue {
//			self.dayPaginator = segue.destination as? UIPageViewController
//		}
//	}
//	
//	override func keyBoardWillHide(_ notification: NSNotification) {
//		addTaskView.adjustViewBasedOnKeyboard(visibility: false, notification: notification)
//	}
//	
//	override func keyBoardWillShow(_ notification: NSNotification) {
//		addTaskView.adjustViewBasedOnKeyboard(visibility: true, notification: notification)
//	}
//	
//	@IBAction func todayButtonTapped(_ sender: Any) {
//		self.activeDate = Date().dateAtStartOf(.day).date
//	}
//	
//	private func setTodoListViewController(_ vc: TodoListViewController?, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
//		if let todoView = vc {
//			todoView.activeDate = activeDate
//			todoView.delegate = self
//			self.addViewController(forPagination: todoView, direction: direction, animated: animated)
//		}
//	}
//	
//	private func addViewController(forPagination taskListView: TodoListViewController, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
//		
//		dayPaginator?.setViewControllers([taskListView],
//									 direction: direction,
//									 animated: animated,
//									 completion: nil)
//	}
//	
//	func saveTodo(_ todo: Todo, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) {
//		let task = Task(context: context)
//		task.setTask(with: todo)
//		context.mr_saveToPersistentStore { (bool, nil) in
//			self.refetchTaskAndScrollToLastRow()
//		}
//	}
//	
//	func refetchTaskAndScrollToLastRow() {
//		(dayPaginator?.viewControllers?.first as? TodoListViewController)?.refreshView(scrollToLastRow: true)
//	}
//}
//
//extension TaskViewController: AddTasker {
//	func addTask(with text: String) {
//		let todo = Todo(title: text, date: activeDate)
//		saveTodo(todo)
//	}
//	
//	func showNextPage() {
//		activeDate = activeDate.dateByAdding(1, .day).date
//		setTodoListViewController(todoListView, direction: .forward)
//	}
//	
//	func showPrevPage() {
//		activeDate = activeDate.dateByAdding(-1, .day).date
//		setTodoListViewController(todoListView, direction: .reverse)
//	}
//	
//	func showTodayPage() {
//		
//		let today = Date().dateAtStartOf(.day)
//		
//		guard today != activeDate else {
//			return
//		}
//		
//		let direction: UIPageViewController.NavigationDirection
//		
//		if today < activeDate {
//			direction =  UIPageViewController.NavigationDirection.reverse
//		} else {
//			direction =  UIPageViewController.NavigationDirection.forward
//		}
//		
//		activeDate = today
//		
//		setTodoListViewController(todoListView, direction: direction)
//	}
//}
//
//extension TaskViewController: DateSliderHelper {
//	func updateSliderHeader(with text: String) {
//		if let title = sliderHeaderLabel.text, title != text {
//			DispatchQueue.main.async {
//				self.sliderHeaderLabel.text = text
//			}
//		}
//	}
//	
//	func didSelectCell(forDate date: Date) {
//		self.activeDate = date
//	}
//}
//
//
////
////	@IBAction func todayButtonTapped(_ sender: Any) {
////		self.showTodayPage()
////	}
////
////	@IBAction func nextButtonTapped(_ sender: Any) {
////		self.showNextPage()
////	}
////
////	@IBAction func prevButtonTapped(_ sender: Any) {
////		self.showPrevPage()
////	}
