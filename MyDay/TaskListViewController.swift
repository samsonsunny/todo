//
//  TaskListViewController.swift
//  MyDay
//
//  Created by Sam on 1/14/18.
//  Copyright © 2018 samsonsunny. All rights reserved.
//

import UIKit
import MagicalRecord

let userDefaults: UserDefaults = UserDefaults.standard

class TaskListViewController: KeyboardViewController {

	@IBOutlet fileprivate weak var addTaskView: UIView!
	@IBOutlet fileprivate weak var addTaskTextField: UITextField!
	@IBOutlet fileprivate weak var addTaskButton: UIButton!
	@IBOutlet fileprivate weak var todoListView: UITableView!
	@IBOutlet fileprivate weak var greyCircleButton: UIButton!
	@IBOutlet fileprivate weak var plusButton: UIButton!
	@IBOutlet fileprivate weak var addTaskLabel: UILabel!
	@IBOutlet fileprivate weak var addTaskViewBottomLayout: NSLayoutConstraint!
//	@IBOutlet fileprivate weak var todayButton: UIButton!
	
	@IBOutlet weak var pageTitle: UILabel!
	
	@IBOutlet fileprivate weak var subtitle: UILabel!
	
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			reload()
			updateHeader()
		}
	}
	
	var tasks: [Task] = [] {
		didSet {
			DispatchQueue.main.async {
				self.todoListView.reloadData()
			}
		}
	}
	
	private lazy var tapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(listViewTapped))
//		gesture.cancelsTouchesInView = true
		return gesture
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		todoListView.delegate = self
		todoListView.dataSource = self
		todoListView.allowsSelection = true
		todoListView.addGestureRecognizer(tapGesture)
		addTaskTextField.delegate = self
		activeDate = Date().dateAtStartOf(.day)
		
		
	}
	
	@IBAction func addNewTask(_ sender: Any) {
		bringFoucsToAddTaskField()
	}
	
	@IBAction func prevButtonTapped(_ sender: Any) {
		activeDate = activeDate.dateByAdding(-1, .day).date
	}
	
	@IBAction func nextButtonTapped(_ sender: Any) {
		activeDate = activeDate.dateByAdding(1, .day).date
	}
	
	@IBAction func todayButtonTapped(_ sender: Any) {
		activeDate = Date().dateAtStartOf(.day)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
//		removeFoucsFromAddTaskField()
	}
	
	@objc func listViewTapped() {
	
		if addTaskTextField.isFirstResponder {
			removeFoucsFromAddTaskField()
		} else {
			bringFoucsToAddTaskField()
		}
	}
	
	@objc override func keyBoardWillHide(_ notification: NSNotification) {
		handleKeyboard(with: notification, keyboardWillShow: false)
	}
	
	@objc override func keyBoardWillShow(_ notification: NSNotification) {
		handleKeyboard(with: notification, keyboardWillShow: true)
	}
	
	func updateHeader() {
//		if activeDate.isToday {
//			todayButton.setTitleColor(UIColor.purple, for: .normal)
//			todayButton.setTitleColor(UIColor.darkGray, for: .highlighted)
//		} else {
//			todayButton.setTitleColor(UIColor.black, for: .normal)
//			todayButton.setTitleColor(UIColor.darkGray, for: .highlighted)
//		}
		// , MMM d
//		pageTitle.text = "My Tasks"
		//activeDate.toFormat("My Tasks")
//		let subText = activeDate.toFormat("EEEE, MMMM d").uppercased()
		//EEEE, MMM d")
//		let title = activeDate.isToday ? "Today": activeDate.isTomorrow ? "Tomorrow": activeDate.isYesterday ? "Yesterday" : activeDate.toFormat("MMM d")
		
		if activeDate.isToday {
			pageTitle.text = "Today"
			subtitle.text = activeDate.toFormat("EEEE,  MMMM d").uppercased()
		} else if activeDate.isTomorrow {
			pageTitle.text = "Tomorrow"
			subtitle.text = activeDate.toFormat("EEEE,  MMMM d").uppercased()
		} else if activeDate.isYesterday {
			pageTitle.text = "Yesterday"
			subtitle.text = activeDate.toFormat("EEEE,  MMMM d").uppercased()
		} else {
			pageTitle.text = activeDate.toFormat("EEEE")
			subtitle.text = activeDate.toFormat("MMMM d").uppercased()
		}
		
//		subtitle.text = subText
//		pageTitle.text = title
	}

	fileprivate func handleKeyboard(with notification: NSNotification, keyboardWillShow: Bool) {
		let keyboardHeight = getKeyboardHeight(from: notification.userInfo)
		adjustAddTaskView(height: keyboardHeight, keyboard: keyboardWillShow)
	}
	
	fileprivate func getKeyboardHeight(from notificationPayload: [AnyHashable : Any]?) -> CGFloat {
		guard let keyboardFrame = notificationPayload?["UIKeyboardBoundsUserInfoKey"] as? CGRect else {
			return 0
		}
		return keyboardFrame.size.height
	}
	
	fileprivate func adjustAddTaskView(height: CGFloat, keyboard isVisible: Bool) {
		self.addTaskViewBottomLayout.constant = isVisible ? height: 0
		UIView.animate(withDuration: 0.25) {
			self.view.layoutIfNeeded()
		}
	}
	
	fileprivate func removeFoucsFromAddTaskField() {
		addTaskTextField.resignFirstResponder()
		UIView.animate(withDuration: 0.25, animations: {
			self.updateTextAfterRemovingFocus()
		})
	}
	
	fileprivate func updateTextAfterRemovingFocus() {
		if let todoText = addTaskTextField.text, todoText.isNotEmpty {
			addTaskTextField.isHidden = false
			addTaskLabel.isHidden = true
			addTaskButton.isHidden = true
			plusButton.isHidden = true
			greyCircleButton.isHidden = false
		} else {
			addTaskTextField.isHidden = true
			addTaskLabel.isHidden = false
			addTaskButton.isHidden = false
			plusButton.isHidden = false
			greyCircleButton.isHidden = true
		}
	}
	
	fileprivate func bringFoucsToAddTaskField() {
		addTaskButton.isHidden = true
		plusButton.isHidden = true
		addTaskLabel.isHidden = true
		addTaskTextField.isHidden = false
		greyCircleButton.isHidden = false
		addTaskTextField.becomeFirstResponder()
	}
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		removeFoucsFromAddTaskField()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell
		let todo = Todo(task: tasks[indexPath.row])
		
		cell?.updateCell(with: todo, delegate: self, indexPath: indexPath)
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: { (_, _) in
			
			let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			
			options.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				
				let task = self.tasks[indexPath.row]
			
				task.mr_deleteEntity(in: .mr_default())
			NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
				
				self.reload()
			}))
			options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
				
			}))
			self.present(options, animated: true, completion: nil)
		})
		return [delete]
	}
}

extension TaskListViewController: TodoCellDelegate {
	func didTodoCompleted(_ todo: Todo?, indexPath: IndexPath?) {
		guard let _todo = todo, let _indexPath = indexPath else {
			return
		}
		let task = tasks[_indexPath.row]
		task.setTask(with: _todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
	}
}

extension TaskListViewController: UITextFieldDelegate {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
//		removeFoucsFromAddTaskField()
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		add(todo: textField.text)
		textField.clear()
		return true
	}
	
	func add(todo title: String?) {
		guard let text = title, text.isNotEmpty else { return }
//		let key = activeDate.toString()
//		var todos: [Todo] = getTodosFromUserDefaults(for: key)
//		todos.append()
//		persistTodosInUserDefaults(todos, for: key)
		
		let todo = Todo(title: text, date: activeDate)
		
		self.saveTodo(todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
//			addTaskTextField.clear()
			self.reload()
			
//			let lastElement = self.tasks.count - 1
			
//			if self.todoListView.numberOfRows(inSection: 0) >= lastElement {
//				self.todoListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)

//			}
			
		}
	}
	
	func reset() {
//		addTaskTextField.clear()
//		addTaskTextField.resignFirstResponder()
		
	}
	
	func reload() {
		tasks = Task.getTasks(for: activeDate)
	}

	@available(*, deprecated)
	func getTodosFromUserDefaults(for key: String) -> [Todo] {
		guard let data = userDefaults.value(forKey: key) as? Data, let todos = try? PropertyListDecoder().decode(Array<Todo>.self, from: data) else {
			return []
		}
		return todos
	}
	
//
//	@available(*, deprecated)
//	func persistTodosInUserDefaults(_ todos: [Todo], for key: String) {
//
//		userDefaults.set(try? PropertyListEncoder().encode(todos), forKey:key)
//	}
	
	func saveTodo(_ todo: Todo, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) {
		
		let task = Task(context: context)
		task.setTask(with: todo)
	}
	
	@available(*, deprecated)
	func migrateUserDefaultsTodosIntoCoreData() {
		let todos = getTodosFromUserDefaults(for: activeDate.toString())
		
		let tasks = todos.map { (todo) -> Task in
			let t = Task(context: NSManagedObjectContext.mr_default())
			t.setTask(with: todo)
			return t
		}
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
	}
}

