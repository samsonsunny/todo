//
//  AccountViewController.swift
//  MyDay
//
//  Created by Sam on 12/1/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

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
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			cell.textLabel?.text = "App Version v1.7"
			
//			let label = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 20))
//			label.frame.size = CGSize(width: 100, height: 70)
			
//			label.text = "Hello"
//			cell.accessoryView = label
//			cell.detailTextLabel?.text = "Hello"
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
		print("Selected")
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.row == 1 {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: "FeedbackViewControllerID")
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
