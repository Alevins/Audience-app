//
//  GSShowWeb.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/12.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSShowWeb: UIViewController {

	@IBOutlet weak var webView: UIWebView!
	var urlString: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		let actionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "buttonAction:")
		self.navigationItem.rightBarButtonItem = actionItem

		if urlString != nil {
			let url = NSURL(string: urlString!)
			let request = NSURLRequest(URL: url!)
			webView.loadRequest(request)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		if webView.loading {
			webView.stopLoading()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Action
	
	func buttonAction(sender: UIBarButtonItem) {
		if urlString != nil {
			let url = NSURL(string: urlString!)
			let activity = SafariActivity()
			let vc = UIActivityViewController(activityItems: [url!], applicationActivities: [activity])
			self.presentViewController(vc, animated: true, completion: nil)
		}
	}
}
