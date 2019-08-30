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
		self.taskTitle = todo.title
		self.dueDate = todo.dueDate
		self.completed = todo.isCompleted
		self.modifiedDate = todo.modifiedDate
	}
	
	class func getTodos(for dueDate: Date, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) -> [Todo] {
		
		guard let tasks = self.mr_find(byAttribute: "dueDate", withValue: dueDate, in: context) as? [Task] else {
			return []
		}
				
		return tasks.map{ Todo(task: $0) }
	}
	
	class func getTasks(for dueDate: Date, in context: NSManagedObjectContext = NSManagedObjectContext.mr_default()) -> [Task] {
		
		let predicate = NSPredicate(format: "dueDate = %@", argumentArray: [dueDate])
		
		guard let tasks = self.mr_findAllSorted(by: "modifiedDate", ascending: true, with: predicate, in: context) as? [Task] else {
			return []
		}
		
		return tasks
	}
}
