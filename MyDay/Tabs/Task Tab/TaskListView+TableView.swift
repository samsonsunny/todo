//
//  TaskListView+TableView.swift
//  abseil
//
//  Created by Sam on 12/18/19.
//

import UIKit

extension TaskListViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return calendarDates.count 
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(integerLiteral: 40)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let (date, isToday) = getTitle(for: section)
		let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 20, height: 40))
		label.text = date
		
		if isToday {
			label.font = UIFont.preferredFont(forTextStyle: .title1).withSize(CGFloat(15))
			label.textColor = UIColor.systemIndigo
		} else {
			label.font = UIFont.preferredFont(forTextStyle: .title1).withSize(CGFloat(15))
			label.textColor = UIColor.gray
		}
		
		let view = UIView(frame: CGRect.zero)
		view.addSubview(label)
		view.backgroundColor = UIColor.systemGray6
		
		return view
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tasks = getTasks(forSection: section) else {
			return 1
		}
		return tasks.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let task = getTask(forIndexPath: indexPath) {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TodoCell {
				cell.updateCell(with: Todo(firTask: task), delegate: self, indexPath: indexPath)
				return cell
			}
			return UITableViewCell()
		}
		return tableView.dequeueReusableCell(withIdentifier: "addTaskCell") ?? UITableViewCell()
	}
	
	func getTask(forIndexPath indexPath: IndexPath) -> FIRTask? {
		
		guard let tasks = getTasks(forSection: indexPath.section) else {
			return nil
		}
		if indexPath.row < tasks.count {
			return tasks[indexPath.row]
		}
		return nil
	}
	
	func getTasks(forSection section: Int) -> [FIRTask]? {
		guard section < calendarDates.count else {
			return nil
		}
		return taskPerDate[calendarDates[section]]
	}
	
//	private func setDateForSection(_ section: Int) -> Date {
//		let newDate = firstYearStartDate.in(region: .local).dateByAdding(section, .day).dateAtStartOf(.day).date
//		datePerSection[section] = newDate
//		return newDate
//	}
//
//	private func getDateFor(section:Int) -> Date {
//		if let storedDate = datePerSection[section] {
//			return storedDate
//		} else {
//			return setDateForSection(section)
//		}
//	}
	
	private func getTitle(for section: Int) -> (String, Bool) {
		
		let date = calendarDates[section] //.in(region: .local).date
		print("total no sections \(calendarDates.count)")
		print(todaySection)
		print(date)
		print(section)
		
		if date.isToday {
			print((date.toFormat("EEEE, MMM d") + "   Today", true))
			return (date.toFormat("EEEE, MMM d") + "   Today", true)
		} else if date.isTomorrow {
			print(date.toFormat("EEEE, MMM d") + "   Tomorrow", false)
			return (date.toFormat("EEEE, MMM d") + "   Tomorrow", false)
		} else if date.isYesterday {
			print(date.toFormat("EEEE, MMM d") + "   Yesterday", false)
			return (date.toFormat("EEEE, MMM d") + "   Yesterday", false)
		} else if date.year == Date().year {
			print(date.toFormat("EEEE, MMM d"), false)
			return (date.toFormat("EEEE, MMM d"), false)
		}
		print(date.toFormat("EEEE, MMM d, ") + "\(Date().dateByAdding(1, .year).year)", false)
		return (date.toFormat("EEEE, MMM d, ") + "\(Date().dateByAdding(1, .year).year)", false)
	}
}

extension TaskListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let task = getTask(forIndexPath: indexPath) {
//			print("task title \(task.title)")
//			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskDetailViewControllerID")
//			self.present(vc, animated: true, completion: nil)
		} else {
			// due date
			activeDate = calendarDates[indexPath.section]
			showAddTaskView()
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
			self.deleteTask(on: indexPath)
		}
		deleteAction.backgroundColor = UIColor.red
		return [deleteAction]
	}
	
//	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//	}
//
//	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//		return true // tableView.numberOfRows(inSection: indexPath.section) == indexPath.row
//	}
}
