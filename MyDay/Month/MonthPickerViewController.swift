//
//  MonthPickerViewController.swift 
//  Wednesday
//
//  Created by Sam on 2/6/19.
//  Copyright © 2019 Mulanthanam. All rights reserved.
//

import UIKit
import SwiftDate


protocol MonthPickerDelegate {
	func didChangeActiveDate(_ date: Date)
	func didSelectPickerDate(_ date: Date)
	var activeDate: Date { get }
}

protocol MonthPickerCollectionViewDelegate {
	func didSelectDateFromCollectionView(_ date: Date)
}


class MonthPickerViewController: UIViewController, MonthPickerDelegate {
	
	// Handles month date is selected
	// Handle what initial month has to be displayed
	
	var activeDate = Date().dateAtStartOf(.day)
	
	@IBOutlet weak var monthViewContainer: UIView!
	
	@IBOutlet weak var monthTitleLabel: UILabel!
	
	var paginator: MonthPageViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = ""
		setMonthNameAsTitle(from: activeDate)
		
		
//		self.navigationController?.navigationBar.shadowImage = nil 
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueID.monthPagination.rawValue {
			
			paginator = segue.destination as? MonthPageViewController
			paginator?.activeDate = activeDate
			paginator?.monthPickerDelegate = self
		}
	}
	
	// whenever the active page is changed
	// Update month title
	
	func didChangeActiveDate(_ date: Date) {

		setMonthNameAsTitle(from: date)
	}
	
	private func setMonthNameAsTitle(from date: Date) {
		if date.year == Date().dateAtStartOf(.day).year {
			monthTitleLabel.text = date.monthName(.default)
		} else {
			monthTitleLabel.text = "\(date.monthName(.default)) \(date.year)"
		}
		
	}
	
	func didSelectPickerDate(_ date: Date) {
		activeDate = date
		loadCalendarView() 
	}
	
	@IBAction func todayButtonTapped(_ sender: Any) {
		paginator?.activeDate = Date().dateAtStartOf(.day).date
		paginator?.setDefaultView()
	}
}

extension MonthPickerViewController {
	func loadCalendarView() {
//		let calendarView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
//		calendarView?.monthPickerDelegte = self
//		calendarView?.activeDate = activeDate
//		calendarView?.modalTransitionStyle = .coverVertical
//		self.present(calendarView!, animated: true, completion: nil)
		
		
		let vc = UIStoryboard(name: "Main", bundle: nil)
		.instantiateViewController(identifier: "TaskViewControllerID") as? TaskViewController
		vc?.activeDate = activeDate
		
		self.navigationController?.pushViewController(vc!, animated: true)
	}
}
