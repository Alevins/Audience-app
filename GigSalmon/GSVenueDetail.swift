//
//  GSVenueDetail.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/02.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Parse

class GSVenueDetail: UIViewController {
	
	var venue: PFObject?
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var locationLabel: UILabel!
	@IBOutlet var aboutButton: UIButton!
	@IBOutlet var locationButton: UIButton!
	@IBOutlet var archivesButton: UIButton!
	@IBOutlet var upcomingsButton: UIButton!
	@IBOutlet var baseView: UIView!
	@IBOutlet var aboutView: UIView!
	@IBOutlet var locationView: UIView!
	@IBOutlet var archivesView: UIView!
	@IBOutlet var upcomingsView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Venue Info"
		self.aboutButton.backgroundColor = UIColor.orangeColor()
		
		if venue != nil {
			nameLabel.text = self.venue!["name"] as? String
			let geocoder = CLGeocoder()
			let venueLocation = self.venue!["location"] as! PFGeoPoint
			let location = CLLocation(latitude: venueLocation.latitude, longitude: venueLocation.longitude)
			geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
				if placemarks.count > 0 {
					let placemark = placemarks[0] as! CLPlacemark
					self.locationLabel.text = placemark.name
				}
			})

			let imageFile = self.venue!["image"] as! PFFile
			imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						self.imageView.image = UIImage(data:imageData)
					}
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Action

	@IBAction func tabButtonAction(sender: UIButton) {
		self.aboutButton.backgroundColor = UIColor.whiteColor()
		self.locationButton.backgroundColor = UIColor.whiteColor()
		self.archivesButton.backgroundColor = UIColor.whiteColor()
		self.upcomingsButton.backgroundColor = UIColor.whiteColor()
		let transition: CATransition = CATransition()
		transition.duration = 0.25
		transition.type = kCATransitionFade
		self.baseView.layer.addAnimation(transition, forKey: nil)
		if sender == self.aboutButton {
			self.aboutButton.backgroundColor = UIColor.orangeColor()
			self.baseView.bringSubviewToFront(self.aboutView)
		} else if sender == self.locationButton {
			self.locationButton.backgroundColor = UIColor.orangeColor()
			self.baseView.bringSubviewToFront(self.locationView)
		} else if sender == self.archivesButton {
			self.archivesButton.backgroundColor = UIColor.orangeColor()
			self.baseView.bringSubviewToFront(self.archivesView)
		} else if sender == self.upcomingsButton {
			self.upcomingsButton.backgroundColor = UIColor.orangeColor()
			self.baseView.bringSubviewToFront(self.upcomingsView)
		}
	}
	
	// MARK: - Segue Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "VenueAboutSegue" {
			let vc = segue.destinationViewController as! GSVenueAbout
			vc.venue = self.venue
		} else if segue.identifier == "VenueLocationSegue" {
			let vc = segue.destinationViewController as! GSVenueLocation
			vc.venue = self.venue
		} else if segue.identifier == "VenueArchivesSegue" || segue.identifier == "VenueUpcomingsSegue" {
			let vc = segue.destinationViewController as! GSVenueArchivesUpcomings
			vc.venue = self.venue
			vc.isArchives = segue.identifier == "VenueArchivesSegue"
		}
	}
}
