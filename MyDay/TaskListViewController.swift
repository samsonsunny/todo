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
		if activeDate.isToday {
			todayButton.isHidden = true
		} else {
			todayButton.isHidden = false 
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
	
	@IBAction func todayButtonTapped(_ sender: Any) {
		paginationHandler?.didTodayButtonTapped()
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
//				+ ", Today").uppercased()
		} else if activeDate.isTomorrow {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
//				+ ", Tomorrow").uppercased()
		} else if activeDate.isYesterday {
			pageTitle.text = activeDate.toFormat("MMM d").uppercased()
			subtitle.text = activeDate.toFormat("EEEE").uppercased()
//				+ ", Yesterday").uppercased()
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
	
//	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//		let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: { (_, _) in
//

//		return [delete]
//	}
	
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
		}
	}
	
	func refetchTaskAndScrollToLastRow() {
		tasks = Task.getTasks(for: activeDate)
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

			let task = self.tasks[indexPath.row]

			task.mr_deleteEntity(in: .mr_default())
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)

			self.refetchTasks()
		}))
		options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
		}))
		self.present(options, animated: true, completion: nil)
	}
}



extension UIColor {
	static var titlePurple: UIColor {
		return UIColor(red: 92/255, green: 30/255, blue: 218/255, alpha: 1)
	}
	
	static var subTitlePurple: UIColor {
		return UIColor(red: 92/255, green: 30/255, blue: 218/255, alpha: 0.6)
	}
	static var titleGrey: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
	}
	
	static var subTitleGrey: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
	}
	
	static var subTitleLightGrey: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
	}
}
