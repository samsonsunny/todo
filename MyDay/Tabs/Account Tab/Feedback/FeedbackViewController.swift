//
//  FeedbackViewController.swift
//  MyDay
//
//  Created by Sam on 12/9/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FeedbackViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	
	private var feedbackRef: CollectionReference!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Feedback"
		self.navigationItem.largeTitleDisplayMode = .always
		self.navigationItem.setRightBarButton(.init(title: "Done", style: .done, target: self, action: #selector(sendFeedback)), animated: false)
		feedbackRef = Firestore.firestore().collection("feedbacks")
        // Do any additional setup after loading the view.
		self.loader.isHidden = true
    }
	
	@objc func sendFeedback() {
		self.loader.isHidden = false
		loader.startAnimating()
		feedbackRef.addDocument(data: ["feedback" : textView.text ?? ""]) { (error) in
			self.loader.stopAnimating()
			self.loader.isHidden = true
			self.showSuccessMessage()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		textView.becomeFirstResponder()
	}
	
	func showSuccessMessage() {
		let vc = UIAlertController(title: "", message: "Feedback sent", preferredStyle: .alert)
		
		let done = UIAlertAction(title: "Close", style: .default) { (action) in
			vc.dismiss(animated: true) {
				self.navigationController?.popViewController(animated: true)
			}
		}
		vc.addAction(done)
		
		self.present(vc, animated: true, completion: nil)
	}
}
