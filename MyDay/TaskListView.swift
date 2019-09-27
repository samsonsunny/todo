//
//  TaskListView.swift
//  MyDay
//
//  Created by Sam on 9/17/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class TaskListView: UITableView {
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var numberOfSections: Int {
		return 1
	}
	
	override func numberOfRows(inSection section: Int) -> Int {
		return 1
	}
	
	override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
		return UITableViewCell()
	}
}
