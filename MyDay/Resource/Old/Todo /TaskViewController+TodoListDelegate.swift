////
////  TaskViewController+TodoListDelegate.swift
////  MyDay
////
////  Created by Sam on 10/19/19.
////  Copyright © 2019 samsonsunny. All rights reserved.
////
//
//import Foundation
//import MagicalRecord
//
//extension TaskViewController: TodoListDelegate {
//	func listViewTapped() {
//		if addTaskView.addTaskTextField.isFirstResponder {
//			addTaskView.removeFoucsFromAddTaskTextField()
//		} else {
//			addTaskView.bringFocusToAddTaskTextField()
//		}
//	}
//	
//	func listViewDragged(_ scrollView: UIScrollView) {
//		if addTaskView.addTaskTextField.isFirstResponder {
//			addTaskView.removeFoucsFromAddTaskTextField()
//		}
//	}
//	
//	func deleteTask(_ task: Task) {
//		task.mr_deleteEntity(in: .mr_default())
//		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
//			(self.dayPaginator?.viewControllers?.first as? TodoListViewController)?.reloadTasks()
//		}
//	}
//	
//	func updateTask(_ task: Task, with todo: Todo) {
//		task.setTask(with: todo)
//		NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (bool, nil) in
//			(self.dayPaginator?.viewControllers?.first as? TodoListViewController)?.reloadTasks()
//		}
//	}
//}
