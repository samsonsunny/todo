//
//  MonthViewController.swift
//  Wednesday
//
//  Created by Sam on 2/28/19.
//  Copyright © 2019 Mulanthanam. All rights reserved.
//

import UIKit
import SwiftDate

class MonthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var delegate: MonthPickerCollectionViewDelegate?
	
	var givenDate = Date()
	
	var monthStartWeekDay: Int {
		return givenDate.dateAtStartOf(.month).weekday - 1
	}
	
	lazy var weekTitleHeader: UIStackView = {
		let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
		self.view.addSubview(stackView)
		let weekShortName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		for index in 0...6 {
			let weekDay = UIButton()
			weekDay.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
			weekDay.setTitle("\(weekShortName[index])", for: .normal)
			weekDay.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
			weekDay.titleLabel?.textAlignment = .left
			stackView.addArrangedSubview(weekDay)
		}
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		return stackView
	}()
	
	lazy var monthCollectionView: UICollectionView = {
		
		let monthViewFrame = CGRect(x: 0, y: weekTitleHeader.frame.height, width: self.view.bounds.width, height: self.view.bounds.height)
		
		var layout = UICollectionViewFlowLayout()
//		layout.scrollDirection = .vertical
//		layout.itemSize = CGSize(width: monthViewFrame.width/7, height: monthViewFrame.height/7)
//		layout.minimumLineSpacing = CGFloat(0)
		layout.minimumInteritemSpacing = CGFloat(0)
		layout.minimumLineSpacing = CGFloat(0)
		
		
		
		let collectionView = UICollectionView(frame: monthViewFrame, collectionViewLayout: layout)
		
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.backgroundColor = UIColor(named: "BackgroundColor")
		collectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
		collectionView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
		return collectionView
	}()
	
	// for the given date generate all dates and construct nice UI
	
	var monthDates: [Date] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		self.view.addSubview(weekTitleHeader)
		self.view.addSubview(monthCollectionView)
		
		var startDate = givenDate.dateAtStartOf(.month).dateAtStartOf(.weekOfMonth).date
		let endDate = givenDate.dateAtEndOf(.month).dateAtEndOf(.weekOfMonth).date
		
		repeat {
			monthDates.append(startDate)
			startDate = startDate.dateByAdding(1, .day).date
		} while (startDate < endDate)
		
//		print("start \(startDate)")
//		print("end \(endDate)")
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return monthDates.count // monthStartWeekDay + givenDate.monthDays
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		//		let correctIndex = indexPath.item + 1 // adding one because WeekDay range 1234567 not 0 through 6
		
		let date = monthDates[indexPath.row]
		
		guard date.month == givenDate.month else {
			// Prev Month Index
			return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
		}
		// Current Month Index
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else {
			return UICollectionViewCell()
		}
		
//		let day = (indexPath.item + 1) - monthStartWeekDay
//		let date = Date(year: givenDate.year, month: givenDate.month, day: day, hour: 0, minute: 0).in(region: Region.current).dateAtStartOf(.day).date
		
		
		
		cell.day.setTitle("\(date.day)", for: .normal)
		cell.day.isUserInteractionEnabled = false
		cell.day.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
		
		cell.date = date
		
//		if date == givenDate {
//			cell.backgroundColor = UIColor.black
//		}
		
		if date.isToday {
//			cell.backgroundColor = UIColor.green
			
			cell.day.tintColor = UIColor.green
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
			let bgColor = cell.backgroundColor
			let color = cell.day.tintColor
			cell.backgroundColor = UIColor.blue
			cell.day.tintColor = UIColor(named: "TitleColor")
			delegate?.didSelectDateFromCollectionView(cell.date)
//			collectionView.deselectItem(at: indexPath, animated: true)
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
				cell.backgroundColor = bgColor
				cell.day.tintColor = color
			}
		}
	}
}

extension MonthViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		return CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.height/8)
	}
}
