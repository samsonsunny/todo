//
//  TodoListViewController.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController {
	
	@IBOutlet weak var todoListView: TaskTableView!
			
	var activeDate: Date = Date().dateAtStartOf(.day) {
		didSet {
			tasks = Task.getTasks(for: activeDate)
		}
	}
	
	private var tasks: [Task] = [] {
		didSet {
			if isViewLoaded {
				todoListView.tasks = tasks
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		todoListView.tasks = tasks
    }
}
