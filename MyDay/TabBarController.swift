//
//  ViewController.swift
//  MyDay
//
//  Created by Sam on 10/16/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("tab bar loaded")
		
		let vc = UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(identifier: "TaskViewControllerID") as? TaskViewController
		(self.viewControllers?.first as? UINavigationController)?
			.pushViewController(vc!, animated: false)
    }
}
