//
//  NavigationController.swift
//  MyDay
//
//  Created by Sam on 10/25/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationBar.setValue(true, forKey: "hidesShadow")
		
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskViewControllerID") as? TaskViewController

		self.pushViewController(vc!, animated: false)
    }

}
