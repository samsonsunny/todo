//
//  DayPaginator.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class DayPaginator: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var pageNumber = 0
	
	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		
		super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
	}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setDefaultPage(direction: .forward)
		self.delegate = self
//		self.dataSource = self
	}
	
//	override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
//		<#code#>
//	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed {
			guard let taskList = (pageViewController.viewControllers?.first) as? TodoListViewController else {
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
	
	func getTaskListView() -> TodoListViewController? {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyBoard.instantiateViewController(withIdentifier: "TodoListViewControllerID") as? TodoListViewController
//		vc?.paginationHandler = self
		return vc
	}
}

//
//extension TaskPageViewController: TaskPageDelegate {
//	func didTodayButtonTapped() {
//		if pageNumber > 0 {
//			pageNumber = 0
//			setDefaultPage(direction: .reverse)
//		} else if pageNumber < 0 {
//			pageNumber = 0
//			setDefaultPage(direction: .forward)
//		}
//	}
//}
