//
//  Todo.swift
//  MyDay
//
//  Created by Sam on 8/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import Foundation
import SwiftDate
//import CoreData
import FirebaseAuth
import FirebaseFirestore

struct Todo: Codable, Equatable {
	var title: String
	var isCompleted: Bool = false
	var dueDate: Date
	var modifiedDate: Date = Date().dateAtStartOf(.day)
	
	init(title: String, date: Date) {
		self.title = title
		self.dueDate = date
		
	}
	
//	init(task: Task) {
//
//		self.title = task.taskTitle
//		self.isCompleted = task.completed
//		self.modifiedDate = task.modifiedDate
//		self.dueDate = task.dueDate
//	}
	
	init(firTask: FIRTask) {
		self.title = firTask.title
		self.isCompleted = firTask.isCompleted
		self.dueDate = firTask.dueOn
	}
}

struct FIRTask {
	var key: String = ""
	var title: String
	var dueOn: Date
	var createdOn: Date
	var createdBy: String
	var isCompleted: Bool
	
//	var sortOrder: Date {
//		return dueOn
//	}
//
	// To order the task in the list. Usually the task will be ordered in ascending order, when a new task is added that will added in the bottom of the day. When it is moved to some other position top then the modifiedOn will be setted as next element modifiedOn time - 1 sec so that it will be ordered above that task. Similarly when a task is moved from top to bottom then the modified date will be added as adjacent task - 1 sec. If it is moved very last then current time will be added
	// Note: It might not work properly when more than one task has same sortorder date 
	
	
//	init(task: Task) {
//		self.title = task.taskTitle
//		self.dueOn = task.dueDate
//		self.createdOn = task.modifiedDate 
//		self.createdBy = Auth.auth().currentUser?.uid ?? ""
//		self.isCompleted = task.completed
//	}
	
	init(withKey key: String, dict: [String: Any]) {
		self.key = key
		self.title = dict["title"] as! String
		self.createdBy = dict["created_by"] as! String
		self.createdOn = (dict["created_on"] as! Timestamp).dateValue()
		self.dueOn = (dict["due_on"] as! Timestamp).dateValue()
		self.isCompleted = dict["is_completed"] as! Bool
	}
	
	init(title: String, dueOn: Date, createdBy: String, createdOn: Date, completed: Bool) {
		self.title = title
		self.createdBy = createdBy
		self.createdOn = createdOn
		self.dueOn = dueOn
		self.isCompleted = completed
	}
	
	var dictionary: [String: Any] {
		return [
			"title": self.title,
			"due_on": self.dueOn,
			"created_on": self.createdOn,
			"created_by": self.createdBy,
			"is_completed": self.isCompleted
		]
	}
}

extension FIRTask: Hashable {
	
}
