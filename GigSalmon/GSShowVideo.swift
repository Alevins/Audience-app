//
//  GSShowVideo.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/10.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSShowVideo: UIViewController {

	@IBOutlet weak var webView: UIWebView!
	var videoId: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let cancelButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		cancelButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		cancelButton.setTitle(GoogleIcon.ebce, forState:.Normal)
		cancelButton.showsTouchWhenHighlighted = true
		cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)

		if videoId != nil {
			let url = NSURL(string: "http://www.youtube.com/embed/\(videoId!)?feature=player_detailpage")
			let request = NSURLRequest(URL: url!)
			webView.loadRequest(request)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Action
	
	func cancelAction(sender: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
