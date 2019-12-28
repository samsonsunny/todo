//
//  AppDelegate.swift
//  MyDay
//
//  Created by Sam on 1/14/18.
//  Copyright © 2018 samsonsunny. All rights reserved.
//

import UIKit
import MagicalRecord
import Firebase
import FirebaseFirestore
import SwiftDate
import StoreKit

let versionNumber = "VersionNumber"
let isPushedAll = "isPushedAll"
let morningTime = "morningTime"
let eveningTime = "eveningTime"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "MyDay")
		FirebaseApp.configure()
		Auth.auth().signInAnonymously(completion: nil)
		
		_ = Firestore.firestore()
		storeVersionNumberInUserDefaults()
		setDefaultReminderLeadTime() 
		SwiftDate.defaultRegion = .local
		SubscriptionService.shared.loadSubscriptionOptions()
		
//		guard let data = SubscriptionService.shared.loadReceipt() else {
//            return true
//        }
        
//        let body = [
//            "receipt-data": data.base64EncodedString(),
//            "password": "656ffc16c93847a48d16cbbda1b37899"
//        ]
//
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			// Enable or disable features based on authorization.
			
			if granted {
				ReminderHelper.resetReminders()
			}
		}
		
		return true
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		// Update the app interface directly.
		
		// Play a sound.
		completionHandler(UNNotificationPresentationOptions.sound)
	}
	
	private func storeVersionNumberInUserDefaults() {
		
		let appVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
		let currentVersion = Double(appVersionString as! String)!
		let storedVersionNumber = UserDefaults.standard.double(forKey: versionNumber)
		
		if storedVersionNumber < currentVersion {
			UserDefaults.standard.set(currentVersion, forKey: versionNumber)
		}
	}
	
	private func setDefaultReminderLeadTime() {
		
		let storedMorningLeadTime = 480
		let storedEveningLeadTime = 1140

		if (UserDefaults.standard.value(forKey: morningTime) as? Int) != nil, (UserDefaults.standard.value(forKey: eveningTime) as? Int) != nil {
			
			ReminderHelper.resetReminders()
		} else {
			UserDefaults.standard.set(storedMorningLeadTime, forKey: morningTime)
			UserDefaults.standard.set(storedEveningLeadTime, forKey: eveningTime)
		}
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
//		self.saveContext()
		
		NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: nil)
	}

}

extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
//        SMLog.info("Purchase state of product id: \(transaction.payment.productIdentifier)")
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        
//        let userDefaults = SharedUtils.getUserDefaults()
        
//        let productId = transaction.payment.productIdentifier
        
        SubscriptionService.shared.upgradePlan { (success) in
			queue.finishTransaction(transaction)
			NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessfulNotification, object: nil)

//            userDefaults.set(productId.contains("monthlypremium") ? AccountType.monthlyPremiumiOS.rawValue: AccountType.yearlyPremiumiOS.rawValue, forKey: "PlanType")
//            AppConfig.shared.updateIntercomDetails()
//            PlanUtils.shared.getPlanDetailsAndSave()
        }
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
//        SMLog.info("Purchase restored for product id: \(transaction.payment.productIdentifier)")
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
//        SMLog.error("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        NotificationCenter.default.post(name: SubscriptionService.purchaseCancelNotification, object: nil)
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
//        SMLog.info("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
    }
	
	/// Called when an error occur while restoring purchases. Notify the user about the error.
	func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
//		if let error = error as? SKError, error.code != .paymentCancelled {
//			DispatchQueue.main.async {
//				self.delegate?.storeObserverDidReceiveMessage(error.localizedDescription)
//			}
//		}
	}

	/// Called when all restorable transactions have been processed by the payment queue.
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//		print(Messages.restorable)
//
//		if !hasRestorablePurchases {
//			DispatchQueue.main.async {
//				self.delegate?.storeObserverDidReceiveMessage(Messages.noRestorablePurchases)
//			}
//		}
	}
    
}
