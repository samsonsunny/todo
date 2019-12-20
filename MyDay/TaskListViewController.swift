//
//  TaskListViewController.swift
//  MyDay
//
//  Created by Sam on 11/30/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

extension Date {
	var totalDaysInYear: Int {
		return self.isLeapYear ? 366 : 365
	}
}

class DateHelper {
	
	let startDate = Date().dateAtStartOf(.year).date
	let endDate = Date().dateAtStartOf(.year).date.dateByAdding(2, .year).date
	let today = Date().dateAtStartOf(.day).date
	
	var indexForToday: Int {
		return twoYearsOfDates.firstIndex(of: today) ?? 0
	}
	
	var twoYearTotalDays: Int {
		return startDate.totalDaysInYear + endDate.totalDaysInYear
	}
	
	var dateForSection352: Date {
		return startDate.dateByAdding(352, .day).date
	}
	
	var twoYearsOfDates: [Date] {
		var dates: [Date] = []
		for i in 0 ..< twoYearTotalDays {
			dates.append(startDate.dateByAdding(i, .day).date)
		}
		return dates
	}
}

class TaskListViewController: KeyboardViewController {

	@IBOutlet weak var taskCalendarListView: UITableView!
		
	lazy var dummyView: UIButton = {
		let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: self.view.bounds.size))
		button.addTarget(self, action: #selector(tapOutside), for: .touchUpInside)
		return button
	}()
	
	var keyWindow: UIWindow? {
		return UIApplication.shared.keyWindow
	}
	
	var addTaskView: CreateTaskView!
	let addTaskViewHeight = CGFloat(100)
	var layer: CAGradientLayer!
	var taskRef: CollectionReference!
	let calendarDates = DateHelper().twoYearsOfDates
	let todaySection = DateHelper().indexForToday
	var taskPerDate: [Date: [FIRTask]] = [:]
	
	var userID: String? {
		return Auth.auth().currentUser?.uid
	}
	
	var activeDate = Date()
	
	var allTasks: [FIRTask] = [] {
		didSet {
			taskPerDate = [:]
			groupTasksByDate(tasks: allTasks)
			DispatchQueue.main.async {
				self.taskCalendarListView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Everyday"
		taskRef = Firestore.firestore().collection("tasks")
		setupTaskListView()
		setupAddTaskView()
		scrollToToday()
		loadTasks {
			self.scrollToToday()
		}
    }
	
	override func keyBoardWillHide(_ notification: NSNotification) {
		UIView.animate(withDuration: 0.25) {
			if let window = self.keyWindow {
				self.addTaskView.frame.origin = CGPoint(x: 0, y: window.frame.height)
			}
			self.view.layoutIfNeeded()
		}
	}
	
	override func keyBoardWillShow(_ notification: NSNotification) {
		UIView.animate(withDuration: 0.25) {
			if let window = self.keyWindow {
				let y = window.frame.height - self.getKeyboardHeight(from: notification.userInfo) - self.addTaskViewHeight
				self.addTaskView.frame.origin = CGPoint(x: 0, y: y)
			}
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func tapOutside() {
		hideAddTaskView()
	}
	
	func setupTaskListView() {
		taskCalendarListView.delegate = self
		taskCalendarListView.dataSource = self
		taskCalendarListView.scrollsToTop = false
	}
	
	func setupAddTaskView() {
		addLayer()
		if let window = keyWindow {
			let frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: addTaskViewHeight)
			addTaskView = CreateTaskView(frame: frame)
			addTaskView.isHidden = false
			window.addSubview(addTaskView)
		}
		addTaskView.saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
	}
	
	func addLayer() {
		layer = CAGradientLayer()
		layer.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
		layer.locations = [0.0 , 1.0]
		layer.startPoint = CGPoint(x: 0.0, y: 1.0)
		layer.endPoint = CGPoint(x: 1.0, y: 1.0)
		layer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
		layer.opacity = 0.5
		dummyView.layer.insertSublayer(layer, at: 0)
		dummyView.isHidden = true
		self.view.addSubview(dummyView)
	}
	
	func getKeyboardHeight(from notificationPayload: [AnyHashable : Any]?) -> CGFloat {
		if let frame = notificationPayload?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
			return frame.size.height
		}
		return 0
	}
	
	func hideAddTaskView() {
		addTaskView.textField.resignFirstResponder()
		addTaskView.isHidden = true
		dummyView.isHidden = true
	}
	
	func showAddTaskView() {
		addTaskView.isHidden = false
		addTaskView.textField.becomeFirstResponder()
		dummyView.isHidden = false
	}
	
	func groupTasksByDate(tasks: [FIRTask]) {
		tasks.forEach { (task) in
			if let tasks = taskPerDate[task.dueOn] {
				var totalTasks = tasks
				totalTasks.append(task)
				taskPerDate[task.dueOn] = Array(Set(totalTasks)).sorted(by: { (task1, task2) -> Bool in
					return task1.createdOn < task2.createdOn
				})
			} else {
				taskPerDate[task.dueOn] = [task]
			}
		}
	}
	
	func resetAddTaskView() {
		hideAddTaskView()
		addTaskView.textField.text = ""
	}
	
	@objc func saveTask() {
		if let title = addTaskView.textField.text, let uid = userID {
			createTask(title: title, dueOn: activeDate, createdBy: uid, isCompleted: false)
		}
	}
	
	func createTask(title: String, dueOn: Date, createdBy: String, isCompleted: Bool) {
		let task = FIRTask(title:  title, dueOn: dueOn, createdBy: createdBy, createdOn: Date(), completed: isCompleted)
		taskRef.addDocument(data: task.dictionary)
		loadTasks {
			let section = self.calendarDates.firstIndex(of: dueOn) ?? self.todaySection
			self.taskCalendarListView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
			self.resetAddTaskView()
		}
	}
	
	func updateTask(on indexPath: IndexPath, completed: Bool) {
		if var task = getTask(forIndexPath: indexPath) {
			task.isCompleted = completed
			taskRef.document(task.key).setData(task.dictionary)
		}
		loadTasks {
			self.resetAddTaskView()
		}
	}
	
	func deleteTask(on indexPath: IndexPath) {
		if let task = getTask(forIndexPath: indexPath) {
			taskRef.document(task.key).delete()
		}
		loadTasks {}
	}
	
	private func loadTasks(completion: @escaping () -> Void) {
		guard let uid = userID else {
			completion()
			return
		}
		fetchTasks(byUserID: uid) { (firTasks) in
			if let tasks = firTasks {
				self.allTasks = tasks
			}
			completion()
		}
	}
	
	private func fetchTasks(byUserID uid: String, completion: @escaping ([FIRTask]?) -> Void) {
		taskRef.whereField("created_by", isEqualTo: uid).getDocuments(source: .cache, completion: { (snapshot, error) in
			let tasks = self.getFIRTasks(byParsingFirestoreSnapshot: snapshot)
			completion(tasks)
		})
	}
	
	private func getFIRTasks(byParsingFirestoreSnapshot snapshot: QuerySnapshot?) -> [FIRTask]? {
		return snapshot?.documents.map({ (snap) -> FIRTask in
			return FIRTask(withKey: snap.documentID, dict: snap.data())
		})
	}
	
	func scrollToActiveDate(animated: Bool = false) {
		DispatchQueue.main.async {
			let section = self.calendarDates.firstIndex(of: self.activeDate) ?? self.todaySection
			let row = 0
			self.taskCalendarListView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: animated)
		}
	}
	
	func scrollToToday(animated: Bool = false) {
		DispatchQueue.main.async {
			self.taskCalendarListView.scrollToRow(at: IndexPath(row: 0, section: self.todaySection), at: .top, animated: animated)
		}
	}
}

extension TaskListViewController: TodoCellDelegate {
	
	func didTaskCompleted(_ completed: Bool, indexPath: IndexPath) {
		updateTask(on: indexPath, completed: completed)
	}
}
