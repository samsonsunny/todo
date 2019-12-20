//
//  LoaderViewController.swift
//  MyDay
//
//  Created by Sam on 11/30/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import MagicalRecord
import FirebaseAuth
import FirebaseFirestore

class LoaderViewController: UIViewController {

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var tasksCollectionRef: CollectionReference?

	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		
		guard !UserDefaults.standard.bool(forKey: isPushedAll) else {
			self.loadTaskListView {
				self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
					return vc == self
				})
			}
			return
		}
		
		self.activityIndicator.startAnimating()
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
			self.tasksCollectionRef = Firestore.firestore().collection("tasks")
			self.pushCoreDataTasksToFirestore {
				UserDefaults.standard.set(true, forKey: isPushedAll)
				self.activityIndicator.stopAnimating()
				self.loadTaskListView {
					self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
						return vc == self
					})
				}
			}
		})
    }
	
	func pushCoreDataTasksToFirestore(block: () -> Void) {
		let documents = Task.getAllDocuments(in: .mr_default())
		documents.forEach { (document) in
			tasksCollectionRef?.addDocument(data: document)
		}
		block()
	}
	
	func loadTaskListView(block: () -> Void) {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewControllerID") as? TabBarViewController
		self.navigationController?.pushViewController(vc!, animated: true)
		block()
	}
}
