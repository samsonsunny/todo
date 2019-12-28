//
//  ReminderViewController.swift
//  MyDay
//
//  Created by Sam on 12/27/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import SwiftDate

class ReminderViewController: UITableViewController {

	@IBOutlet weak var morningReminderTime: UILabel!
	@IBOutlet weak var eveningReminderTime: UILabel!
	
	@IBOutlet weak var morningDatePicker: UIDatePicker!
	@IBOutlet weak var eveningDatePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		morningDatePicker.isHidden = true
//		eveningDatePicker.isHidden = true
		
		morningReminderTime.isHidden = true
		eveningReminderTime.isHidden = true
		
		let storedMorningLeadTime = UserDefaults.standard.value(forKey: morningTime) as? Int ?? 480
		let storedEveningLeadTime = UserDefaults.standard.value(forKey: eveningTime) as? Int ?? 1140
		
		morningDatePicker.date = morningDatePicker.date.dateAtStartOf(.day).date.dateByAdding(storedMorningLeadTime, .minute).date
		eveningDatePicker.date = eveningDatePicker.date.dateAtStartOf(.day).date.dateByAdding(storedEveningLeadTime, .minute).date
    }
	
	func reloadTable() {
		DispatchQueue.main.async {
			self.tableView.beginUpdates()
			self.tableView.reloadData()
			self.tableView.endUpdates()
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			
//		if indexPath.row == 0 {
//			if morningDatePicker.isHidden {
//				morningDatePicker.isHidden = false
//				reloadTable()
//			} else {
//				morningDatePicker.isHidden = true
//				reloadTable()
//			}
//		} else if indexPath.row == 2 {
//			if eveningDatePicker.isHidden {
//				eveningDatePicker.isHidden = false
//				reloadTable()
//			} else {
//				eveningDatePicker.isHidden = true
//				reloadTable()
//			}
//		}
		
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
//		if morningDatePicker.isHidden && indexPath.row == 1 {
//			return 0
//		}
//
//		if eveningDatePicker.isHidden && indexPath.row == 3 {
//			return 0
//		}
		
//		if indexPath.row == 2 || indexPath.row == 4 {
////			morningDatePicker.isHidden = true
//			return 0
//		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	@IBAction func morningReminderTimeChanged(_ sender: UIDatePicker) {
		
		let morningLeadTime = (sender.date.hour * 60) + sender.date.minute
		UserDefaults.standard.set(morningLeadTime, forKey: morningTime)
		ReminderHelper.resetReminders()
	}
	
	@IBAction func eveningReminderTimeChanged(_ sender: UIDatePicker) {
		
		let eveningLeadTime = (sender.date.hour * 60) + sender.date.minute
		UserDefaults.standard.set(eveningLeadTime, forKey: eveningTime)
		ReminderHelper.resetReminders()
	}
}

class ReminderHelper {
	
	class func resetReminders() {
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		
		let storedMorningLeadTime = UserDefaults.standard.value(forKey: morningTime) as? Int ?? 480
		let storedEveningLeadTime = UserDefaults.standard.value(forKey: eveningTime) as? Int ?? 1140
	
		scheduleMorningReminders(hour: storedMorningLeadTime.quotientAndRemainder(dividingBy: 60).quotient ,
								 min: storedMorningLeadTime.quotientAndRemainder(dividingBy: 60).remainder)
		
		scheduleEveningReminder(hour: storedEveningLeadTime.quotientAndRemainder(dividingBy: 60).quotient,
								min: storedEveningLeadTime.quotientAndRemainder(dividingBy: 60).remainder)
	}
	
	class func scheduleMorningReminders(hour: Int, min: Int) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: "Good Morning!", arguments: nil)
		content.body = NSString.localizedUserNotificationString(forKey: "Start your day with a plan. Review your today's tasks.", arguments: nil)
		content.sound = UNNotificationSound.default
		
		// Configure the trigger for a 7am wakeup.
		var dateInfo = DateComponents()
		dateInfo.hour = hour
		dateInfo.minute = min
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
		 
		// Create the request object.
		let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
		
		// Schedule the request.
		let center = UNUserNotificationCenter.current()
		center.add(request) { (error : Error?) in
			if let theError = error {
				print(theError.localizedDescription)
			}
		}
	}
	
	class func scheduleEveningReminder(hour: Int, min: Int) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: "Hey! How was your day?", arguments: nil)
		content.body = NSString.localizedUserNotificationString(forKey: "See what you have finished and plan for tomorrow", arguments: nil)
		content.sound = UNNotificationSound.default
		
		// Configure the trigger for a 7am wakeup.
		var dateInfo = DateComponents()
		dateInfo.hour = hour
		dateInfo.minute = min
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
		 
		// Create the request object.
		let request = UNNotificationRequest(identifier: "EveningAlarm", content: content, trigger: trigger)
		
		// Schedule the request.
		let center = UNUserNotificationCenter.current()
		center.add(request) { (error : Error?) in
			if let theError = error {
				print(theError.localizedDescription)
			}
		}
	}
}
