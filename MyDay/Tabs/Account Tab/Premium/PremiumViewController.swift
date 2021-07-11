//
//  PremiumViewController.swift
//  MyDay
//
//  Created by Sam on 12/21/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

//  https://developer.apple.com/documentation/storekit/in-app_purchase/offering_completing_and_restoring_in-app_purchases

private var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()

class PremiumViewController: UIViewController {

	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var purchaseButton: UIButton!
	
	let activityView = UIActivityIndicatorView(style: .large)
    fileprivate var safariViewController: SFSafariViewController?

	var isAuthorizedForPayments: Bool {
		return SKPaymentQueue.canMakePayments()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		purchaseButton.layer.cornerRadius = 10
		logo.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
		
		activityView.center = self.view.center
		self.view.addSubview(activityView)
		activityView.color = UIColor.darkGray
		let price = (SubscriptionService.shared.options?.first?.formattedPrice ?? "$0.49") + " - Monthly"
		purchaseButton.setTitle(price, for: .normal)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if SubscriptionService.shared.options == nil  {
//		   activityView.startAnimating()
//			guard isAuthorizedForPayments else {
//				return
//			}
		    SubscriptionService.shared.loadSubscriptionOptions()
		}
		NotificationCenter.default.addObserver(self,
													  selector: #selector(handlePurchaseSuccessfull(notification:)),
													  name: SubscriptionService.purchaseSuccessfulNotification,
													  object: nil)
	}
    
	@IBAction func closeView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func handlePurchase(_ sender: Any) {
		print("show loader")
		
//		guard isAuthorizedForPayments else {
//			return
//		}
		
		activityView.startAnimating()
		
//		guard SubscriptionService.shared.hasReceiptData else {
//
//            return
//        }
		
		let plan = SubscriptionService.shared.options?.first
		_ = SubscriptionService.shared.purchase(plan: plan!)
	}
	
	@IBAction func showTermsPage(_ sender: Any) {
		loadSafariView()
	}
	   
	func loadSafariView() {

		guard let pageURL = URL(string: "https://samsonsunny.github.io/todo-subscription") else {
		   return
		}


		self.safariViewController = SFSafariViewController(url: pageURL, entersReaderIfAvailable: false)
		self.safariViewController?.delegate = self as SFSafariViewControllerDelegate

		if #available(iOS 11.0, *) {
		  self.safariViewController?.dismissButtonStyle = SFSafariViewController.DismissButtonStyle.cancel
		  self.safariViewController?.preferredBarTintColor = UIColor.white
		  self.safariViewController?.modalPresentationStyle = .popover
//		  self.safariViewController?.preferredControlTintColor = UIColor.setmoreGreen

		}

		if let safariView = self.safariViewController {
			self.present(safariView, animated: true, completion: nil)
		}
	}
	
//	func subscribePlan(for type: Bool) {
//
//        activityView.startAnimating()
//
//        guard SubscriptionService.shared.hasReceiptData else {
//            _ = SubscriptionService.shared.purchase(plan: (type ? SubscriptionService.shared.options?[1] : SubscriptionService.shared.options?[0])!)
//            return
//        }
//
//        _ = SubscriptionService.shared.latestReceipt(completion: { (success, isReceiptLinked, companyKey) in
////            if success && isReceiptLinked {
////                AnalyticsManager.shared.trackEvent(.subscription, action: .subscriptionFailureDifferentAccount)
////                self.alertPop(message: "Receipt Error: Purchase has been made already using current AppleID with different Setmore Account.")
////                self.alertView?.hideAlert()
////            } else {
////                _ = SubscriptionService.shared.purchase(plan: (type
////                    ? SubscriptionService.shared.options?[1] : SubscriptionService.shared.options?[0])!)
////            }
//        })
//    }
    
    @objc func handlePurchaseSuccessfull(notification: Notification) {
        DispatchQueue.main.async {
			self.activityView.stopAnimating()
			 self.dismiss(animated: true, completion: nil)
		}
    }
    
    @objc func handlePurchaseCancel(notification: Notification) {
//        self.alertView?.showMessage("Payment cancelled", duration: 2)
		DispatchQueue.main.async {
			self.activityView.stopAnimating()
		}
    }
    
     @objc func handleOptionsLoaded(notification: Notification) {
        DispatchQueue.main.async {
			self.activityView.stopAnimating()
		}
    }

    @objc func handleOptionsFailed(notification: Notification) {
//        alertPop(message: "Something went wrong contacting the AppStore. Please check your internet connection and try again.")
        DispatchQueue.main.async {
			self.activityView.stopAnimating()
		}
//        self.alertView?.hideAlert()
    }
}

extension PremiumViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
    }
}

/** The struct which holds the SKProduct information.
 */

public struct Subscription {
    let product: SKProduct
    let formattedPrice: String
    let desc: String
    let title: String
    let price: NSDecimalNumber
    let priceLocale: String
    
    
    init(product: SKProduct) {
		
		print(product)
        self.product = product
        
        if formatter.locale != self.product.priceLocale {
            formatter.locale = self.product.priceLocale
        }
        desc = self.product.localizedDescription
        title = self.product.localizedTitle
        priceLocale = self.product.priceLocale.currencyCode ?? ""
        price = self.product.price
		formatter.locale = product.priceLocale
        formattedPrice = formatter.string(from: product.price) ?? "\(product.price)"  //?.trimmingCharacters(in: NSCharacterSet.whitespaces) ?? "\(product.price)"
    }
}

public class SubscriptionService: NSObject, SKRequestDelegate {
    
    public static let shared = SubscriptionService()
   
	let receiptRefreshRequest = SKReceiptRefreshRequest()
    let receiptURL = Bundle.main.appStoreReceiptURL
    static let sessionIdSetNotification = Notification.Name("SubscriptionServiceSessionIdSetNotification")
    public static let optionsLoadedNotification = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
    public static let optionsFailureNotification = Notification.Name("SubscriptionServiceOptionsFailureNotification")
    public static let restoreSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
    public static let purchaseSuccessfulNotification = Notification.Name("SubscriptionServicePurchaseSuccessfulNotification")
    public static let purchaseCancelNotification = Notification.Name("SubscriptionServicePurchaseCancelNotification")
    public static let purchaseFailureNotification = Notification.Name("SubscriptionServicePurchaseFailureNotification")
    
//    var currentSubscription: PaidSubscription? //Record of latest activeSubscription
//    var purchasedSubscription: PaidSubscription? //Record of latest subscription
    
    /** This property holds the array of subscriptions(Plans).
     */
    
    public var options: [Subscription]?
    
    /** This property returns 'bool' value if receipt is present or not.
     */
    
    public var hasReceiptData: Bool {
        return loadReceipt() != nil
    }
    
    /**
     This method loads the purchase receipt present in the application bundle.
     - Returns : Returns encrypted receipt data from application bundle.
     */
    
    public func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    /**
     This method requests StoreKit with Product ID's to load subscriptions.
     */
    
    public func loadSubscriptionOptions() {
//        let productIDPrefix = Bundle.main.bundleIdentifier! + ".sub."
//        let annualPremium = productIDPrefix + PlanType.yearly.rawValue
//        let monthlyPremium  = productIDPrefix + PlanType.monthly.rawValue
//        let productIDs = Set([monthlyPremium, annualPremium])
        let request = SKProductsRequest(productIdentifiers: Set(["monthlyPremium"]))
        request.delegate = self
        request.start()
    }
    
    private func purchaseSubscription(forType: Subscription) {
        let payment = SKMutablePayment(product: forType.product)
        SKPaymentQueue.default().add(payment)
    }
    
    /**
     This method requests StoreKit to make a purchase and adds to queue.
     - parameter plan: A purchasing subscription.
     */
    
    public func purchase(plan: Subscription) {
        self.purchaseSubscription(forType: plan)
    }
    
    /**
     This method passes the encrypted receipt to Setmore server for validation.
     */
    
    public func upgradePlan(completion: ((_ success: Bool) -> Void)? = nil) {
        guard let receiptURL = receiptURL else {
            return
        }
        do {
            let receipt = try Data(contentsOf: receiptURL)
			
			let body = [
				"receipt-data": receipt.base64EncodedString(),
				"password": "656ffc16c93847a48d16cbbda1b37899"
			]
        } catch {
            //            receiptRefreshRequest.start()
        }
    }
    
    /**
     This method requests server for the latest receipt for an account.
     */
    
    public func latestReceipt(completion: ((_ success: Bool, _ isReceiptLinked: Bool, _ companyKey: String) -> Void)? = nil) {
        
//        guard let data = loadReceipt() else {
//            return
//        }
//        
//        let body = [
//            "receipt-data": data.base64EncodedString(),
//            "password": "656ffc16c93847a48d16cbbda1b37899"
//        ]
//
//        _ = InAppApiService.shared.verifyReceipt(data: body, onCompletion: { (handler) in
//            SMLog.info("Latest receipt response::\(handler.json)")
//
//            guard handler.isSuccess else {
//                completion?(false, false, "")
//                return
//            }
//
//            guard !handler.json["data"]["accountInfo"].isEmpty else {
//                completion?(true, false, "")
//                return
//            }
//
//            if !handler.json["data"]["accountInfo"][0]["companyKey"].stringValue.isEqualToString(SmUtils.shared.loggedInCompanyKey) {
//                completion?(true, true, SmUtils.shared.loggedInCompanyKey)
//            } else {
//                completion?(true, false, "")
//            }
//
//        })
    }
}


// MARK: - SKProductsRequestDelegate

extension SubscriptionService: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { Subscription(product: $0) }
		NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: nil)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
             NotificationCenter.default.post(name: SubscriptionService.optionsFailureNotification, object: nil)
        }
    }
}
