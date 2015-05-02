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
	@IBOutlet var eventNameLabel: UILabel!
	@IBOutlet var venueNameLabel: UILabel!
	@IBOutlet var eventDescriptionLabel: UILabel!
	@IBOutlet var venueAddressLabel: UILabel!
	@IBOutlet var eventImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let cancelButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		cancelButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		cancelButton.setTitle(GoogleIcon.ebce, forState:.Normal)
		cancelButton.showsTouchWhenHighlighted = true
		cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
		
		let date = self.event!["date"] as! NSDate
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMMdd HH:mm"
		self.title = dateFormatter.stringFromDate(date) + " START"
		
		eventNameLabel.text = self.event!["title"] as? String
		let venue = self.event!["venue"] as! PFObject
		venueNameLabel.text = "@" + (venue["name"] as! String)
		eventDescriptionLabel.text = self.event!["description"] as? String
		
		let geocoder = CLGeocoder()
		let venueLocation = venue["location"] as! PFGeoPoint
		let location = CLLocation(latitude: venueLocation.latitude, longitude: venueLocation.longitude)
		geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
			if placemarks.count > 0 {
				let placemark = placemarks[0] as! CLPlacemark
				self.venueAddressLabel.text = placemark.name
			}
		})
		
		let imageFile = self.event!["image"] as! PFFile
		imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
			if error == nil {
				if let imageData = imageData {
					self.eventImageView.image = UIImage(data:imageData)
				}
			}
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Action
	
	func cancelAction(sender: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Segue Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowVenueDetailSegue" {
			let venueDetail = segue.destinationViewController as! GSVenueDetail
			venueDetail.venue = self.event!["venue"] as? PFObject
		}
	}
}
