//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Sam on 8/24/19.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdDate: Date
    @NSManaged public var dueDate: Date
    @NSManaged public var title: String
}
