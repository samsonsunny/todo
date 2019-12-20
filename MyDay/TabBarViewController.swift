//
//  TabBarViewController.swift
//  MyDay
//
//  Created by Sam on 12/1/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

	var lastSelectedIndex = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
		self.delegate = self 
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		lastSelectedIndex = selectedIndex
    }
	
	
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
				
		if let taskListVC = (viewController as? UINavigationController)?.viewControllers.first as? TaskListViewController {
			if ((lastSelectedIndex == 0) && (selectedIndex == 0)) {
				taskListVC.scrollToToday(animated: true)
			}
			self.title = "Hello"
		} else {
			self.title = "Hi"
		}
	}
}
