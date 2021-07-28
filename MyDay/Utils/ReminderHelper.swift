//
//  ReminderHelper.swift
//  MyDay
//
//  Created by Sam on 7/14/21.
//  Copyright © 2021 samsonsunny. All rights reserved.
//

import Foundation
import UserNotifications

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
		content.body = NSString.localizedUserNotificationString(forKey: "Start your day with a plan. \n Review your today's tasks.", arguments: nil)
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
