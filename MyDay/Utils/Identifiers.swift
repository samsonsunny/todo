//
//  Identifiers.swift
//  MyDay
//
//  Created by Sam on 10/19/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import Foundation

let versionNumber = "VersionNumber"
let morningTime = "morningTime"
let eveningTime = "eveningTime"

enum SegueID: String {
	case monthPagination = "monthPaginationSegue"
	case dayPagination = "dayPaginationSegue"
}

enum ViewController {
	case todoList
	
	var id: String {
		return "TodoListViewControllerID"
	}
}
