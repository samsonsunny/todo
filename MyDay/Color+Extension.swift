//
//  Color+Extension.swift
//  MyDay
//
//  Created by Sam on 9/17/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

extension UIColor {
	static var titlePurple: UIColor {
		return UIColor(red: 100/255, green: 20/255, blue: 200/255, alpha: 1)
	}
	
	static var subTitlePurple: UIColor {
		return titlePurple.withAlphaComponent(0.8)
	}
	
	static var titleGrey: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
	}
	
	static var subTitleGrey: UIColor {
		return titleGrey.withAlphaComponent(0.6)
	}
	
	static var subTitleLightGrey: UIColor {
		return titleGrey.withAlphaComponent(0.4)
	}
}
