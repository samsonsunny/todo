//
//  Utils.swift
//  MyDay
//
//  Created by Sam on 8/14/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

extension UIView {
	func repositionBasedOnKeyboardChanges(height: CGFloat, shows: Bool) -> CGPoint {
		let y = shows ? self.frame.origin.y - height: self.frame.origin.y + height
		return CGPoint(x: self.frame.origin.x, y: y)
	}
	
	func repositionView(position: CGPoint, animation timing: TimeInterval) {
		UIView.animate(withDuration: timing) {
			self.frame.origin = position
		}
	}
}

extension UITextField {
	func clear() {
		self.text = nil
	}
}

extension String {
	var isNotEmpty: Bool {
		return !self.isEmpty
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

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
