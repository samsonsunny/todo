//
//  Task+CoreDataClass.swift
//  
//
//  Created by Sam on 8/24/19.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
	func setTask(with todo: Todo) {
		self.title = todo.title
		self.dueDate = todo.dueDate
		self.completed = todo.isCompleted
		self.createdDate = todo.createdDate 
	}
	
	class func getTodos(for dueDate: Date, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) -> [Todo] {
		
		guard let tasks = self.mr_find(byAttribute: "dueDate", withValue: dueDate, in: context) as? [Task] else {
			return []
		}
				
		return tasks.map{ Todo(task: $0) }
	}
	
	class func getTasks(for dueDate: Date, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) -> [Task] {
		
		guard let tasks = self.mr_find(byAttribute: "dueDate", withValue: dueDate, in: context) as? [Task] else {
			return []
		}
		
		return tasks
	}
	
}
