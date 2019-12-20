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

let versionNumber = "VersionNumber"
let isPushedAll = "isPushedAll"

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
		
		SwiftDate.defaultRegion = .local 
		return true
	}
	
	private func storeVersionNumberInUserDefaults() {
		
		let appVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
		let currentVersion = Double(appVersionString as! String)!
		let storedVersionNumber = UserDefaults.standard.double(forKey: versionNumber)
		
		if storedVersionNumber < currentVersion {
			UserDefaults.standard.set(currentVersion, forKey: versionNumber)
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

