//
//  TabBarViewController.swift
//  MyDay
//
//  Created by Sam on 12/1/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

	private var lastSelectedIndex = 0
	
	private var isTaskListTabTappedAgain: Bool {
		(lastSelectedIndex == 0) && (selectedIndex == 0)
	}
	
	private func rescheduleReminders() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			if granted {
				ReminderHelper.resetReminders()
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
		self.delegate = self
		
		rescheduleReminders()
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		lastSelectedIndex = selectedIndex
    }
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if let taskListVC = (viewController as? UINavigationController)?.viewControllers.first as? TaskListViewController, isTaskListTabTappedAgain {
			taskListVC.scrollToToday(animated: true)
		}
	}
}
