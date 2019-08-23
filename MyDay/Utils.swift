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
