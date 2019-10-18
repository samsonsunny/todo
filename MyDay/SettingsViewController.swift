//
//  SettingsViewController.swift
//  MyDay
//
//  Created by Sam on 10/12/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UITextViewDelegate {

	@IBOutlet weak var notes: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
//		notes.text
		
//		notes.translatesAutoresizingMaskIntoConstraints = true
		
		notes.delegate = self
		
		notes.sizeToFit()
		
		print(notes.text)
		
		print(notes.frame.size)
		
		print(notes.contentSize)
		
		print(notes.sizeThatFits(CGSize(width: 410, height: 128)))
//		self.tableView.estimatedRowHeight = 100
//		self.tableView.rowHeight = UITableView.automaticDimension
    }
    

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.row == 1 {
			
			
			let x = notes.sizeThatFits(CGSize(width: self.view.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
			
			print("size \(x)")
			
			return x
				
				
//			return 300
		} else {
			return 100
		}
		
//		return // UITableView.automaticDimension
	}

	func textViewDidChange(_ textView: UITextView) {
		
		let x = textView.sizeThatFits(CGSize(width: self.view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
		
		self.tableView.beginUpdates()
		self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
		self.tableView.endUpdates()
	}
}

// https://stackoverflow.com/questions/31595524/resize-uitableviewcell-containing-uitextview-upon-typing
