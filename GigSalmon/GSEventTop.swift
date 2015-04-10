//
//  GSEventTop.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/07.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GSEventTop: UIViewController, CLLocationManagerDelegate {

	@IBOutlet var listView: UITableView!
	var locationManager = CLLocationManager()
	var isListView: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupBarButtons()
//		self.toggleNavigationBarTranslucent()
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupBarButtons() {
		let label = UILabel(frame: CGRectMake(0, 0, 60, 24))
		label.textColor = UIColor.blackColor()
		label.textAlignment = .Right
		label.text = "100km"
		let distanceItem = UIBarButtonItem(customView: label)
		
		let filterButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		filterButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		filterButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
		filterButton.setTitle(GoogleIcon.e6c2, forState:.Normal)
		filterButton.showsTouchWhenHighlighted = true
		filterButton.addTarget(self, action: "filterAction:", forControlEvents: .TouchUpInside)
		let filterItem = UIBarButtonItem(customView: filterButton)
		
		let listButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		listButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		listButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		listButton.setTitle(GoogleIcon.e683, forState: UIControlState.Normal)
		listButton.showsTouchWhenHighlighted = true
		listButton.addTarget(self, action: "listAction:", forControlEvents: UIControlEvents.TouchUpInside)
		let listItem = UIBarButtonItem(customView: listButton)
		
		self.navigationItem.rightBarButtonItems = [listItem, filterItem, distanceItem]
	}
	
	func toggleNavigationBarTranslucent() {
		var image: UIImage? = self.isListView ? nil : UIImage()
		var translucent: Bool = !self.isListView
		self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
		self.navigationController?.navigationBar.shadowImage = image
		self.navigationController?.navigationBar.translucent = translucent
	}
	
	func filterAction(sender: UIBarButtonItem) {
		let storyboard = UIStoryboard(name: "EventSearch", bundle: nil)
		let nav = storyboard.instantiateViewControllerWithIdentifier("EventSearchNav") as! UINavigationController
		let vc = nav.topViewController as! GSEventSearch
		vc.delegate = self
		self.presentViewController(nav, animated: true, completion: nil)
	}
	
	func listAction(sender: UIBarButtonItem) {
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			var transition: UIViewAnimationTransition
			var listViewHidden: Bool
			if (self.isListView) {
				transition = .FlipFromLeft
				listViewHidden = true
			} else {
				transition = .FlipFromRight
				listViewHidden = false
			}
			UIView.setAnimationTransition(transition, forView: self.view, cache: true)
			self.listView?.hidden = listViewHidden
			self.isListView = !self.isListView
//			self.toggleNavigationBarTranslucent()
			})
	}
	
	// MARK: - Delegate methods
	
	func dismissSearchView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - CLLocationManagerDelegate
	
	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		switch status {
		case .NotDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .Restricted, .Denied:
			self.alertLocationServicesDisabled()
			break
		case .AuthorizedAlways, .AuthorizedWhenInUse:
			break
		default:
			break
		}
	}

	func alertLocationServicesDisabled() {
		let title = "Location Services Disabled"
		let message = "You must enable Location Services to show your location."
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { action in
			let url = NSURL(string: UIApplicationOpenSettingsURLString)
			UIApplication.sharedApplication().openURL(url!)
		}))
		alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}
}
