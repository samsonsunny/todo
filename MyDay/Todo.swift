//
//  Todo.swift
//  MyDay
//
//  Created by Sam on 8/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import Foundation
import SwiftDate
import CoreData

struct Todo: Codable, Equatable {
	var title: String
	var isCompleted: Bool = false
	var dueDate: Date
	var createdDate: Date = Date().dateAtStartOf(.day)
	
	init(title: String, date: Date) {
		self.title = title
		self.dueDate = date
		
	}
	
	init(task: Task) {
		self.title = task.title
		self.isCompleted = task.completed
		self.createdDate = task.createdDate
		self.dueDate = task.dueDate
	}
}
