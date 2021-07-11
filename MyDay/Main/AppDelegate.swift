//
//  AppDelegate.swift
//  MyDay
//
//  Created by Sam on 1/14/18.
//  Copyright © 2018 samsonsunny. All rights reserved.
//

import UIKit
//import MagicalRecord
import Firebase
import FirebaseFirestore
import SwiftDate
import StoreKit
import AuthenticationServices

let versionNumber = "VersionNumber"

let morningTime = "morningTime"
let eveningTime = "eveningTime"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		SwiftDate.defaultRegion = .local
		FirebaseApp.configure()
		_ = Firestore.firestore()
		SubscriptionService.shared.loadSubscriptionOptions()		
		return true
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(UNNotificationPresentationOptions.sound)
	}
}

extension AppDelegate: SKPaymentTransactionObserver {
	
	func paymentQueue(_ queue: SKPaymentQueue,
					  updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
			case .purchased: handlePurchasedState(for: transaction, in: queue)
			default: return
			}
		}
	}
	
	func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
		SubscriptionService.shared.upgradePlan { (success) in
			queue.finishTransaction(transaction)
			NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessfulNotification, object: nil)
		}
	}
}
