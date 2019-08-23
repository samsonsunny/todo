//
//  Todo.swift
//  MyDay
//
//  Created by Sam on 8/18/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import Foundation
import SwiftDate

struct Todo: Codable, Equatable {
	var title: String
	var isCompleted: Bool = false
	var dueDate: Date
	var createdDate: Date = Date().dateAtStartOf(.day)
	
	init(title: String, date: Date) {
		self.title = title
		self.dueDate = date 
	}
}
