//
//  AppDelegate.swift
//  MyDay
//
//  Created by Sam on 1/14/18.
//  Copyright © 2018 samsonsunny. All rights reserved.
//

import AuthenticationServices
import Firebase
import FirebaseFirestore
import StoreKit
import SwiftDate
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AppConfigurator().configure()
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


struct AppConfigurator {

	private func configureFirebase() {
		FirebaseApp.configure()
		setupFirestore()
	}

	private func setupFirestore() {
		_ = Firestore.firestore()
	}
	
	private func configureInAppPurchase() {
		SubscriptionService.shared.loadSubscriptionOptions()
	}
	
	private func configureSwiftDate() {
		SwiftDate.defaultRegion = .local
	}
	
	func configure() {
		configureSwiftDate()
		configureFirebase()
		configureInAppPurchase()
	}
}
