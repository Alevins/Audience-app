//
//  GSEventDetail.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/01.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Parse

class GSEventDetail: UIViewController {

	var event: PFObject?
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var venueNameLabel: UILabel!
	@IBOutlet weak var eventDescriptionLabel: UILabel!
	@IBOutlet weak var venueAddressLabel: UILabel!
	@IBOutlet weak var eventImageView: UIImageView!
	@IBOutlet weak var contentBaseView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let date = self.event!["date"] as! NSDate
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMMdd HH:mm"
		self.title = dateFormatter.stringFromDate(date) + " START"
		
		eventNameLabel.text = self.event!["title"] as? String
		let venue = self.event!["venue"] as! PFObject
		venueNameLabel.text = "@" + (venue["name"] as! String)
		eventDescriptionLabel.text = self.event!["description"] as? String

		let addressString = venue["address_ja"] as? String
		if addressString != nil {
			venueAddressLabel.text = addressString!
		}
		
		let imageFile = self.event!["image"] as! PFFile
		imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
			if error == nil {
				if let imageData = imageData {
					self.eventImageView.image = UIImage(data:imageData)
				}
			}
		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController!.view.viewWithTag(10)!.hidden = true
	}
	
	override func viewDidLayoutSubviews() {
		self.scrollView.contentSize = self.contentBaseView.frame.size
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Action
	
	// MARK: - Segue Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowVenueDetailSegue" {
			let venueDetail = segue.destinationViewController as! GSVenueDetail
			venueDetail.venue = self.event!["venue"] as? PFObject
		}
	}
}
