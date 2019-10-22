//
//  DateSliderView.swift
//  MyDay
//
//  Created by Sam on 10/21/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import SwiftDate

protocol DateSliderHelper: class {
	func didSelectCell(forDate date: Date)
}

class DateSliderView: UICollectionView {
	
	let currentYear: Int = Date().dateAtStartOf(.day).year
	
	var selectedDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			guard let index = self.dates.firstIndex(of: selectedDate) else {
				return
			}
			let indexPath = IndexPath(item: index, section: 0)
			let isDateVisible = self.indexPathsForVisibleItems.contains(indexPath)
			self.reloadData()

			if !isDateVisible {
				scrollTo(date: selectedDate)
			}
			
//			let cell = self.cellForItem(at: indexPath)?.frame
		}
	}
	
	let dates = Date.enumerateDates(
		from: Date().dateAtStartOf(.day).dateByAdding(-1000, .day).date,
		to: Date().dateAtStartOf(.day).dateByAdding(1000, .day).date,
		increment: DateComponents(day: 1))
	
	var helper: DateSliderHelper?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.delegate = self
		self.dataSource = self
	}
	
	func scrollTo(date: Date, animated: Bool = true) {
		guard let index = self.dates.firstIndex(of: date) else {
			return
		}
		self.scrollToItem(at: IndexPath(item: index-1, section: 0), at: .left, animated: animated)
	}
	
	func sliderTitle() {
		let sortedRows = self.indexPathsForVisibleItems.map { (indexPath) -> Int in
			return indexPath.row
		}.sorted(by: <)
		
		if let firstRow = sortedRows.first, let lastRow = sortedRows.last {
			
			let firstDate = dates[firstRow]
			let lastDate = dates[lastRow]
			
			if firstDate.year == currentYear && lastDate.year == currentYear {
				if firstDate.month == lastDate.month {
					print(firstDate.monthName(.default))
				} else {
					print("\(firstDate.monthName(.default)) - \(lastDate.monthName(.default))")
				}
			} else {
				if firstDate.month == lastDate.month {
					print("\(firstDate.monthName(.default)) \(firstDate.year)")
				} else {
					if firstDate.year == lastDate.year {
						print("\(firstDate.monthName(.default)) - \(lastDate.monthName(.default)) \(firstDate.year)")
					} else {
						print("\(firstDate.monthName(.default)) \(firstDate.year) - \(lastDate.monthName(.default)) \(lastDate.year)")
					}
					
				}
			}
		}
	}
}

extension DateSliderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dates.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as? DaySliderCell else {
			return UICollectionViewCell()
		}
		guard indexPath.row < numberOfItems(inSection: 0) else {
			return UICollectionViewCell()
		}
		cell.updateCell(with: dates[indexPath.row], selectedDate: selectedDate)
		sliderTitle()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard indexPath.row < numberOfItems(inSection: 0) else {
			return
		}
		helper?.didSelectCell(forDate: dates[indexPath.row])
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 54, height: 54)
	}
}

class DaySliderCell: UICollectionViewCell {
	
	@IBOutlet weak var weekDayLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	
	private var date: Date? {
		didSet {
			guard let activeDate = date else {
				return
			}
			self.updateText(from: activeDate)
		}
	}
	
	override var isSelected: Bool {
		didSet {
			self.updateBorder()
			self.updateTextColor()
		}
	}
	
	func updateCell(with date: Date, selectedDate: Date) {
		self.date = date
		self.isSelected = selectedDate == date
	}
	
	private func updateText(from date: Date) {
		self.dayLabel.text = "\(date.day)"
		self.weekDayLabel.text = (date.isToday ? "Today": date.weekdayName(.short)).uppercased()
	}
	
	private func updateBorder() {
		if isSelected {
			self.setBorder(radius: 12, color: UIColor.systemIndigo)
		} else {
			self.setBorder(radius: 12, color: UIColor.systemGray5)
		}
	}
	
	private func updateTextColor() {
		if isSelected {
			self.weekDayLabel.textColor = UIColor.systemIndigo
			self.dayLabel.textColor	= UIColor.systemIndigo
		} else {
			self.weekDayLabel.textColor = UIColor.black.withAlphaComponent(0.8)
			self.dayLabel.textColor	= UIColor.black
		}
	}
}
