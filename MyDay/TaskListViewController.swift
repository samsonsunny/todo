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
	
	@IBOutlet weak var todayButton: RoundedButton!
	@IBOutlet weak var editButton: RoundedButton!
	
	@IBOutlet fileprivate weak var addTaskView: UIView!
	@IBOutlet fileprivate weak var addTaskTextField: UITextField!
	@IBOutlet fileprivate weak var addTaskButton: UIButton!
	@IBOutlet fileprivate weak var todoListView: UITableView!
	@IBOutlet fileprivate weak var greyCircleButton: UIButton!
	@IBOutlet fileprivate weak var plusButton: UIButton!
	@IBOutlet fileprivate weak var addTaskLabel: UILabel!
	@IBOutlet fileprivate weak var addTaskViewBottomLayout: NSLayoutConstraint!
	@IBOutlet weak var pageTitle: UILabel!
	@IBOutlet fileprivate weak var subtitle: UILabel!
	
	weak var paginationHandler: TaskPageDelegate? 
	
	var pageNumber: Int = 0
	
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			refetchTasks()
			updateHeader()
		}
	}
	
	var tasks: [Task] = []
	
	private lazy var tapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(listViewTapped))
		gesture.cancelsTouchesInView = false
		gesture.delegate = self
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
		activeDate = Date().dateAtStartOf(.day).dateByAdding(pageNumber, .day).date
		toggleTodayButton()
		toggleEditButton()
	}
	
	func toggleTodayButton() {
		if activeDate.isToday {
			todayButton.isHidden = true
		} else if todoListView.isEditing {
			todayButton.isHidden = true
		} else {
			todayButton.isHidden = false
		}
	}
	
	func toggleEditButton() {
		if tasks.isEmpty {
			editButton.isHidden = true
			self.todoListView.setEditing(false, animated: true)
		} else {
			editButton.isHidden = false
		}
	}
	
	func toggleAddTaskButton() {
		if todoListView.isEditing {
			addTaskView.isHidden = true
		} else {
			addTaskView.isHidden = false
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if activeDate.isToday {
			pageTitle.textColor = UIColor.titlePurple
			subtitle.textColor = UIColor.subTitlePurple
		} else {
			pageTitle.textColor = UIColor.titleGrey
			subtitle.textColor = UIColor.subTitleGrey
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeFoucsFromAddTaskField()
		adjustAddTaskView(height: 0, keyboard: false)
	}
	
	@IBAction func todayButtonTapped(_ sender: Any) {
		paginationHandler?.didTodayButtonTapped()
	}
	
	@IBAction func editButtonTapped(_ sender: Any) {
		if editButton.titleLabel?.text == "Edit" {
			self.todoListView.setEditing(true, animated: true)
			editButton.setTitle("Done", for: .normal)
			removeFoucsFromAddTaskField()
		} else {
			self.todoListView.setEditing(false, animated: true)
			editButton.setTitle("Edit", for: .normal)
		}
		toggleAddTaskButton()
		toggleTodayButton()
	}
	
	@IBAction func addNewTask(_ sender: Any) {
		bringFoucsToAddTaskField()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		removeFoucsFromAddTaskField()
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

		if activeDate.isToday {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
		} else if activeDate.isTomorrow {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
		} else if activeDate.isYesterday {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
		} else {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
		}
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
		
		guard !todoListView.isEditing else {
			return
		}
		
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

extension TaskListViewController: TodoCellDelegate {
	func didTodoCompleted(_ todo: Todo?, indexPath: IndexPath?) {
		guard let _todo = todo, let _indexPath = indexPath else {
			return
		}
		let task = tasks[_indexPath.row]
		task.setTask(with: _todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
	}
	
	func didMoreMenuTapped(on indexPath: IndexPath?) {
		guard let taskIndexPath = indexPath else {
			return
		}
		promptDeleteAlert(for: taskIndexPath)
	}
}

extension TaskListViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let location = touch.location(in: todoListView)
		if todoListView.indexPathForRow(at: location) != nil {
			return false
		}
		return true
	}
}

extension TaskListViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, text.isNotEmpty else {
			removeFoucsFromAddTaskField()
			return true
		}
		add(todo: text)
		textField.clear()
		return true
	}
	
	func add(todo title: String) {

		let todo = Todo(title: title, date: activeDate)
		
		self.saveTodo(todo)
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
			self.refetchTaskAndScrollToLastRow() 
		}
	}
	
	func refetchTasks() {
		tasks = Task.getTasks(for: activeDate)
		DispatchQueue.main.async {
			self.todoListView.reloadData()
			self.toggleEditButton()
			self.toggleAddTaskButton()
		}
	}
	
	func refetchTaskAndScrollToLastRow() {
		tasks = Task.getTasks(for: activeDate)
		toggleEditButton()
		DispatchQueue.main.async {
			self.todoListView.reloadData()
			let lastRow = self.todoListView.numberOfRows(inSection: 0) - 1
			self.todoListView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
		}
	}

	func saveTodo(_ todo: Todo, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) {
		let task = Task(context: context)
		task.setTask(with: todo)
	}
	
	func promptDeleteAlert(for indexPath: IndexPath) {
		let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		options.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			self.deleteTodo(inRow: indexPath.row)
		}))
		options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
		}))
		self.present(options, animated: true, completion: nil)
	}
	
	func deleteTodo(inRow row: Int) {
		let task = self.tasks[row]
		task.mr_deleteEntity(in: .mr_default())
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
		refetchTasks()
	}
}
