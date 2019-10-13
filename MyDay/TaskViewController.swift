//
//  TaskViewController.swift
//  MyDay
//
//  Created by Sam on 9/17/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TaskViewController: KeyboardViewController {
	
	@IBOutlet weak var daySegmentedView: UISegmentedControl!
	
	@IBOutlet weak var addTaskView: AddTaskView!
	
	@IBOutlet weak var pageContainer: UIView!
	
	let paginator: DayPaginator = DayPaginator(transitionStyle: .scroll, navigationOrientation: .horizontal)
	
	var activeSegmentIndex: Int = 1 {
		didSet {
			
			paginator.setDefaultPage(direction: .forward)
			
//			if oldValue != activeSegmentIndex {
//				if activeSegmentIndex == 0 {
//					paginator.setDefaultPage(direction: .reverse)
//				} else if activeSegmentIndex == 2 {
//					paginator.setDefaultPage(direction: .forward)
//				} else if activeSegmentIndex > oldValue {
//					paginator.setDefaultPage(direction: .reverse)
//				} else if activeSegmentIndex < oldValue {
//					paginator.setDefaultPage(direction: .forward)
//				}
//			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

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
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "pagination" {
//			self.paginator = segue.destination as? DayPaginator
//		}
//	}
	
	@IBAction func dayChanged(_ sender: UISegmentedControl) {
		activeSegmentIndex = sender.selectedSegmentIndex
//		switch sender.selectedSegmentIndex {
//		case 0:
//			print("0")
//			activeSegmentIndex = sender.selectedSegmentIndex
//			paginator.setDefaultPage(direction: .forward)
//		case 1:
//			print("1")
//			paginator.setDefaultPage(direction: .reverse)
//		case 2:
//			print("2")
//			paginator.setDefaultPage(direction: .reverse)
//		default:
//			print("wrong option")
//		}
	}
	
	@objc override func keyBoardWillHide(_ notification: NSNotification) {

		addTaskView.adjustViewBasedOnKeyboard(visibility: false, notification: notification)
	}
	
	@objc override func keyBoardWillShow(_ notification: NSNotification) {
		
		addTaskView.adjustViewBasedOnKeyboard(visibility: true, notification: notification)
	}
}
