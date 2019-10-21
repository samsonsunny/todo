//
//  DateSliderView.swift
//  MyDay
//
//  Created by Sam on 10/21/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import SwiftDate

class DateSliderView: UICollectionView {
	
	var selectedDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			if let index = dates.firstIndex(of: selectedDate) {
				self.reloadItems(at: [IndexPath(item: index, section: 0)])
			}
		}
	}
	
	let dates = Date.enumerateDates(from: Date().dateAtStartOf(.day).dateByAdding(-1000, .day).date, to: Date().dateAtStartOf(.day).dateByAdding(1000, .day).date, increment: DateComponents(day: 1))
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.delegate = self
		self.dataSource = self
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
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
//		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as? DaySliderCell else {
//			return
//		}
//		cell.setBorder(radius: 15, color: UIColor.black)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 54, height: 54)
	}
}

extension UIView{

	func setBorder(radius: CGFloat, color: UIColor = UIColor.clear) {
		self.layer.cornerRadius = CGFloat(radius)
		self.layer.borderWidth = 1
		self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
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
