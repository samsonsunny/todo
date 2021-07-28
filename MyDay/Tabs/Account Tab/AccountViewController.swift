//
//  AccountViewController.swift
//  MyDay
//
//  Created by Sam on 12/1/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import StoreKit

class AccountViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Account"
		tableView.delegate = self
		tableView.dataSource = self
    }
}

extension AccountViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			cell.textLabel?.text = "Premium"
			cell.accessoryType = .disclosureIndicator

			return cell
		}
		
		if indexPath.row == 1 {
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			cell.textLabel?.text = "Restore purchase"
			cell.accessoryType = .disclosureIndicator

			return cell
		}
		
		if indexPath.row == 3 {
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			cell.textLabel?.text = "Reminder"
			cell.accessoryType = .disclosureIndicator
			return cell
		}
		
		if indexPath.row == 4 {
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

			cell.textLabel?.text = "App Version v1.7"
			
			return cell
		}
		let cell =  UITableViewCell()
		cell.textLabel?.text = "Feedback"
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(70)
	}
}

extension AccountViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.row == 2 {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: "FeedbackViewControllerID")
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		if indexPath.row == 1 {
			print("restore purchase")
			if (SKPaymentQueue.canMakePayments()) {
				
			  SKPaymentQueue.default().restoreCompletedTransactions()
			}
		}
		if indexPath.row == 0 {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: "PremiumViewControllerID")
			self.present(vc, animated: true, completion: nil)
		}
		
		if indexPath.row == 3 {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: "ReminderViewControllerID")
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
