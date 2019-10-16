//
//  MonthViewPagination.swift
//  Wednesday
//
//  Created by Sam on 2/28/19.
//  Copyright © 2019 Mulanthanam. All rights reserved.
//

import UIKit
import SwiftDate

// Handling the pagination for the given date and gestures
// Inform to its parent when some thing happened on pages

class MonthPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MonthPickerCollectionViewDelegate {
	
	var monthPickerDelegate: MonthPickerDelegate?
	
	var activeDate = Date().dateAtStartOf(.day) {
		didSet {
			monthPickerDelegate?.didChangeActiveDate(activeDate)
		}
	}
	
//	var prevMonthDate: Date {
//		return activeDate.dateAtStartOf(.month).dateByAdding(-1, .month).date
//	}
//	var nextMonthDate: Date {
//		return activeDate.dateAtStartOf(.month).dateByAdding(1, .month).date
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = self
		delegate = self
		let vc = MonthViewController()
		vc.givenDate = activeDate
		vc.delegate = self
		setViewControllers([vc], direction: .forward, animated: false, completion: nil)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let vc = MonthViewController()
		vc.givenDate = activeDate.dateByAdding(-1, .month).date
		vc.delegate = self
		return vc
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let vc = MonthViewController()
		vc.givenDate = activeDate.dateByAdding(1, .month).date
		vc.delegate = self
		return vc
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		guard completed else {
			return
		}
		activeDate = (pageViewController.viewControllers?.first as! MonthViewController).givenDate
	}
	
	func didSelectDateFromCollectionView(_ date: Date) {
		monthPickerDelegate?.didSelectPickerDate(date)
	}
}
