//
//  TaskPageViewController.swift
//  MyDay
//
//  Created by Sam on 9/4/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

protocol TaskPageDelegate: class {
	func didTodayButtonTapped()
}

class TaskPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var pageNumber = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setDefaultPage(direction: .forward)
		
		self.delegate = self
		self.dataSource = self
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed {
			guard let taskList = (pageViewController.viewControllers?.first) as? TaskListViewController else {
				return
			}
			pageNumber = taskList.pageNumber
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		let _taskListView = getTaskListView()
		_taskListView?.pageNumber = pageNumber - 1
		
		return _taskListView
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		let _taskListView = getTaskListView()
		_taskListView?.pageNumber = pageNumber + 1
		
		return _taskListView
	}
	
	func setDefaultPage(direction: NavigationDirection) {
		let _taskListView = getTaskListView()
		_taskListView?.pageNumber = pageNumber
		
		self.setViewControllers([_taskListView!], direction: direction, animated: true, completion: nil)
	}
	
	func getTaskListView() -> TaskListViewController? {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyBoard.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController
		vc?.paginationHandler = self 
		return vc
	}
}

extension TaskPageViewController: TaskPageDelegate {
	func didTodayButtonTapped() {
		if pageNumber > 0 {
			pageNumber = 0
			setDefaultPage(direction: .reverse)
		} else if pageNumber < 0 {
			pageNumber = 0
			setDefaultPage(direction: .forward)
		}
	}
}
