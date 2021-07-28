//
//  CustomViews.swift
//  MyDay
//
//  Created by Sam on 7/14/21.
//  Copyright © 2021 samsonsunny. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}

class TopCornerRoundedView: UIView {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		roundCorners(corners: [.topLeft, .topRight], radius: 15)
	}
}
