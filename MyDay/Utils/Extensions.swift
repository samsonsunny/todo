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

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
