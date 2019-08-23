//
//  ViewController.swift
//  MyDay
//
//  Created by Sam on 1/14/18.
//  Copyright © 2018 samsonsunny. All rights reserved.
//

import UIKit

let userDefaults: UserDefaults = UserDefaults.standard

class ViewController: UIViewController {

	@IBOutlet fileprivate weak var addTaskView: UIView!
	@IBOutlet fileprivate weak var addTaskTextField: UITextField!
	@IBOutlet fileprivate weak var addTaskButton: UIButton!
	@IBOutlet fileprivate weak var todoListView: UITableView!
	@IBOutlet fileprivate weak var greyCircleButton: UIButton!
	@IBOutlet fileprivate weak var plusButton: UIButton!
	@IBOutlet fileprivate weak var addTaskLabel: UILabel!
	@IBOutlet fileprivate weak var addTaskViewBottomLayout: NSLayoutConstraint!
	@IBOutlet weak var todayButton: UIButton!
	@IBOutlet weak var subtitle: UILabel!
	
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			reset()
			updateHeader()
		}
	}
	
	var todos: [Todo] = [] {
		didSet {
			DispatchQueue.main.async {
				self.todoListView.reloadData()
			}
		}
	}
	
	private lazy var tapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(listViewTapped))
		gesture.cancelsTouchesInView = false 
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
	
	override func viewWillAppear(_ animated: Bool) {
		addKeyboardNotificationObservers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		removeKeyboardNotificationObservers()
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
	}
	
	@objc func listViewTapped() {
		removeFoucsFromAddTaskField()
	}
	
	@objc func keyBoardWillHide(_ notification: NSNotification) {
		handleKeyboardAppearance(with: notification, keyboardWillShow: false)
	}
	
	@objc func keyBoardWillShow(_ notification: NSNotification) {
		handleKeyboardAppearance(with: notification, keyboardWillShow: true)
	}
	
	func updateHeader() {
		if activeDate.isToday {
//			todayButton.backgroundColor = UIColor.purple.withAlphaComponent(0.9)
			todayButton.setTitleColor(UIColor.purple, for: .normal)
			todayButton.setTitleColor(UIColor.darkGray, for: .highlighted)
//			subtitle.textColor = UIColor.purple
		} else {
//			todayButton.backgroundColor = UIColor.white
			todayButton.setTitleColor(UIColor.black, for: .normal)
			todayButton.setTitleColor(UIColor.darkGray, for: .highlighted)
//			subtitle.textColor = UIColor.darkGray
		}
		subtitle.text = activeDate.toFormat("EEEE, MMM d")
	}
}

// Keyboard Handlers
extension ViewController {
	
	fileprivate func addKeyboardNotificationObservers() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyBoardWillHide),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyBoardWillShow),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
	}
	
	fileprivate func removeKeyboardNotificationObservers() {
		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillHideNotification,
												  object: nil)
		NotificationCenter.default.removeObserver(self,
												  name: UIResponder.keyboardWillShowNotification,
												  object: nil)
	}
	
	fileprivate func handleKeyboardAppearance(with notification: NSNotification, keyboardWillShow: Bool) {
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
		addTaskTextField.resignFirstResponder()
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

		removeFoucsFromAddTaskField()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell
		cell?.updateCell(with: todos[indexPath.row], activeDate: activeDate)
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}

extension ViewController: UITextFieldDelegate {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		removeFoucsFromAddTaskField()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		addTodo(textField.text)
		reset()
		return true
	}
	
	func addTodo(_ todo: String?) {
		guard let text = todo, text.isNotEmpty else { return }
		let key = activeDate.toString()
		var todos: [Todo] = getTodosFromUserDefaults(for: key)
		todos.append(Todo(title: text, date: activeDate))
		persistTodosInUserDefaults(todos, for: key)
	}
	
	func reset() {
		addTaskTextField.clear()
		addTaskTextField.resignFirstResponder()
		todos = getTodosFromUserDefaults(for: activeDate.toString())
	}
	
	func getTodosFromUserDefaults(for key: String) -> [Todo] {
		guard let data = userDefaults.value(forKey: key) as? Data, let todos = try? PropertyListDecoder().decode(Array<Todo>.self, from: data) else {
			return []
		}
		return todos
	}
	
	func persistTodosInUserDefaults(_ todos: [Todo], for key: String) {
		userDefaults.set(try? PropertyListEncoder().encode(todos), forKey:key)
	}
}
