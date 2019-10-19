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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setMonthNameAsTitle(from: activeDate)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueID.monthPagination.rawValue {
			(segue.destination as? MonthPageViewController)?.activeDate = activeDate
			(segue.destination as? MonthPageViewController)?.monthPickerDelegate = self
		}
	}
	
	// whenever the active page is changed
	// Update month title
	
	func didChangeActiveDate(_ date: Date) {

		setMonthNameAsTitle(from: date)
	}
	
	private func setMonthNameAsTitle(from date: Date) {
		self.title = date.monthName(.default)
	}
	
	func didSelectPickerDate(_ date: Date) {
		activeDate = date
		loadCalendarView() 
	}
	
	@objc func todayButtonTapped() {
		
	}
}

extension MonthPickerViewController {
	func loadCalendarView() {
//		let calendarView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
//		calendarView?.monthPickerDelegte = self
//		calendarView?.activeDate = activeDate
//		calendarView?.modalTransitionStyle = .coverVertical
//		self.present(calendarView!, animated: true, completion: nil)
		
		
//		let vc = UIStoryboard(name: "Main", bundle: nil)
//		.instantiateViewController(identifier: "TaskViewControllerID") as? TaskViewController
//		vc?.selectedDateFromCalendar = activeDate
		
		self.navigationController?.pushViewController(agendaView!, animated: true)
	}
	
	var agendaView: AgendaViewController? {
		return UIStoryboard(name: "Main", bundle: nil)
		.instantiateViewController(identifier: "AgendaViewControllerID") as? AgendaViewController
	}
}
