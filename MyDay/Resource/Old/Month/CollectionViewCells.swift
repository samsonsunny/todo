//
//  CollectionViewCells.swift
//  Wednesday
//
//  Created by Sam on 2/28/19.
//  Copyright © 2019 Mulanthanam. All rights reserved.
//

import UIKit


class DayCell: UICollectionViewCell {
	
//	var date: Date = Date()
	
	@IBOutlet weak var day: UIButton!
	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		self.backgroundColor = UIColor.blue
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		fatalError("init(coder:) has not been implemented")
//	}
	
	override func awakeFromNib() {
//		self.backgroundColor = UIColor.white
	}
	
	
	var date: Date = Date() {
			didSet {
				
				self.updateText(from: date)
			}
		}
		
		override var isSelected: Bool {
			didSet {
//				self.updateBorder()
				self.updateTextColor()
			}
		}
		
	func updateCell(with date: Date, selectedDate: Date = Date().dateAtStartOf(.day).date) {
			self.date = date
			self.isSelected = selectedDate == date
		}
		
		private func updateText(from date: Date) {
			self.day.titleLabel?.text = "\(date.day)"
			
		}
		
		private func updateBorder() {
			if isSelected {
				self.setBorder(radius: 12, color: UIColor.systemIndigo)
	//		} else if let date = date, date.isToday {
	//			self.setBorder(radius: 12, color: UIColor.gray)
			} else {
				self.setBorder(radius: 12, color: UIColor.systemGray5)
			}
		}
		
		private func updateTextColor() {
			
			if isSelected {
				self.day.setTitleColor(UIColor.systemIndigo, for: .normal)
//			} else if self.date.isToday {
//
//				self.day.setTitleColor(UIColor.systemBlue, for: .normal)// .titleLabel?.textColor	= UIColor.black
			} else {
				self.day.setTitleColor(UIColor.black, for: .normal)
			}
			
		}
}

class EmptyCell: UICollectionViewCell {
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		self.backgroundColor = UIColor.red
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		fatalError("init(coder:) has not been implemented")
//	}
	override func awakeFromNib() {
//		self.backgroundColor = UIColor.white
	}

}
