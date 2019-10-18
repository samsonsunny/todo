//
//  DayPaginator.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class DayPaginator: UIPageViewController, UIPageViewControllerDelegate {
		
	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		
		super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
	}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
//		self.setViewControllers([viewController!], direction: .forward, animated: false, completion: nil)
	}
}

