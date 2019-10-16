//
//  CollectionViewCells.swift
//  Wednesday
//
//  Created by Sam on 2/28/19.
//  Copyright © 2019 Mulanthanam. All rights reserved.
//

import UIKit


class DayCell: UICollectionViewCell {
	
	var date: Date = Date()
	
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
