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
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var aboutButton: UIButton!
	@IBOutlet weak var locationButton: UIButton!
	@IBOutlet weak var archivesButton: UIButton!
	@IBOutlet weak var upcomingsButton: UIButton!
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var aboutView: UIView!
	@IBOutlet weak var locationView: UIView!
	@IBOutlet weak var archivesView: UIView!
	@IBOutlet weak var upcomingsView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Venue Info"
		self.aboutButton.backgroundColor = UIColor.orangeColor()
		
		if venue != nil {
			nameLabel.text = self.venue!["name"] as? String
			let addressString = self.venue!["address_ja"] as? String
			if addressString != nil {
				self.locationLabel.text = addressString!
			}

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
	
	// MARK: - DelegateMethods
	
	func showImageViewWithImage(image: UIImage!) {
		self.performSegueWithIdentifier("ShowImageSegue", sender: image)
	}
	
	func showVideoViewWithId(videoId: String) {
		self.performSegueWithIdentifier("ShowVideoSegue", sender: videoId)
	}
	
	func showWebViewWithUrl(url: String) {
		self.performSegueWithIdentifier("ShowWebSegue", sender: url)
	}
	
	// MARK: - Segue Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "VenueAboutSegue" {
			let vc = segue.destinationViewController as! GSVenueAbout
			vc.venue = self.venue
			vc.delegate = self
		} else if segue.identifier == "VenueLocationSegue" {
			let vc = segue.destinationViewController as! GSVenueLocation
			vc.venue = self.venue
		} else if segue.identifier == "VenueArchivesSegue" || segue.identifier == "VenueUpcomingsSegue" {
			let vc = segue.destinationViewController as! GSVenueArchivesUpcomings
			vc.venue = self.venue
			vc.isArchives = segue.identifier == "VenueArchivesSegue"
		} else if segue.identifier == "ShowImageSegue" {
			let vc = segue.destinationViewController as! GSShowImage
			vc.image = (sender as! UIImage)
		} else if segue.identifier == "ShowVideoSegue" {
			let nav = segue.destinationViewController as! UINavigationController
			let vc = nav.topViewController as! GSShowVideo
			vc.videoId = (sender as! String)
		} else if segue.identifier == "ShowWebSegue" {
			let vc = segue.destinationViewController as! GSShowWeb
			vc.urlString = (sender as! String)
		}
	}
}
