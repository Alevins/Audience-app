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
import Parse

class GSEventTop: UIViewController, CLLocationManagerDelegate {
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var listView: UITableView!
	@IBOutlet var eventGlanceContainer: UIView!
	var eventGlance: GSEventGlance?
	var distanceLabel: UILabel?
	var locationManager = CLLocationManager()
	var isListView: Bool = false
	var keyword: String! = ""
	var category: String! = ""
	var currentDate: NSDate! = NSDate()
	var filterBarView: UIView?
	var filterLabel: UILabel?
	var filterDeleteButton: UIButton?
	var dateBarView: UIView?
	var dateButton: UIButton?
	var dateNextButton: UIButton?
	var datePrevButton: UIButton?
	var tabBarHeight: CGFloat = 0.0
	var navBarHeight: CGFloat = 0.0
	var eventsArray: [AnyObject] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupNavBarButtons()
		self.setupFilterBar()
		self.setupDateBar()
		
		// LocationManager permission
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		// center UserLocation
		self.mapView.userLocation.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions(), context: nil)

//		self.insertDemoData()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		NSUserDefaults().setInteger(1, forKey: "selectedTabIndex")
		NSUserDefaults().synchronize()
		self.refreshDataSource()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
	}

	override func viewDidLayoutSubviews() {
		self.tabBarHeight = self.tabBarController!.tabBar.frame.height
		self.navBarHeight = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height
		
		let screenBounds = UIScreen.mainScreen().bounds
		let dateBarHeight: CGFloat = 36
		self.dateBarView!.frame = CGRectMake(0, screenBounds.size.height - tabBarHeight - dateBarHeight, screenBounds.size.width, dateBarHeight)
		self.dateButton!.center = CGPointMake(screenBounds.size.width / 2, self.dateBarView!.bounds.size.height / 2)
		self.dateNextButton!.frame = CGRectMake(screenBounds.size.width - 30 - 12, 3, 30, 30)
		self.datePrevButton!.frame = CGRectMake(12, 3, 30, 30)
		
		let filterBarHeight: CGFloat = count(keyword) > 0 || count(category) > 0 ? 36 : 0
		self.filterBarView!.frame = CGRectMake(0, self.navBarHeight, screenBounds.size.width, filterBarHeight)
		self.filterLabel!.frame = CGRectMake(12, 8, screenBounds.size.width - 12 - 30 - 12 - 6, 20)
		self.filterDeleteButton!.frame = CGRectMake(screenBounds.size.width - 30 - 12, 3, 30, 30)

		let glanceHeight: CGFloat = self.mapView!.selectedAnnotations != nil && self.mapView!.selectedAnnotations.count > 0 ? 120 : 0
		self.eventGlanceContainer.frame = CGRectMake(0, screenBounds.size.height - glanceHeight - self.tabBarHeight, screenBounds.size.width, glanceHeight)

		self.listView.contentInset = UIEdgeInsetsMake(self.navBarHeight + filterBarHeight, 0, self.tabBarHeight + dateBarHeight, 0)
	}
	
	func onOrientationChange(notification: NSNotification) {
		let deviceOrientation: UIDeviceOrientation! = UIDevice.currentDevice().orientation
		let glanceHeight: CGFloat = self.mapView!.selectedAnnotations != nil && self.mapView!.selectedAnnotations.count > 0 ? 120 : 0
		let screenBounds = UIScreen.mainScreen().bounds
		self.eventGlanceContainer.frame = CGRectMake(0, screenBounds.size.height - glanceHeight - self.tabBarHeight, screenBounds.size.width, glanceHeight)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupNavBarButtons() {
		self.distanceLabel = UILabel(frame: CGRectMake(0, 0, 70, 24))
		self.distanceLabel!.textColor = UIColor.blackColor()
		self.distanceLabel!.textAlignment = .Right
		let distanceItem = UIBarButtonItem(customView: self.distanceLabel!)
		
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
	
	func setupDateBar() {
		let effect = UIBlurEffect(style: .Dark)
		self.dateBarView = UIVisualEffectView(effect: effect)
		self.navigationController!.view.addSubview(self.dateBarView!)
		
		// date label
		self.dateButton = UIButton(frame: CGRectMake(0, 0, 100, 30))
		self.dateButton!.titleLabel!.font = UIFont.systemFontOfSize(14)
		self.dateButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		self.dateButton!.showsTouchWhenHighlighted = true
		self.dateButton!.addTarget(self, action: "dateButtonAction:", forControlEvents: .TouchUpInside)
		self.dateBarView!.addSubview(self.dateButton!)
		self.updateDateButton()
		
		// next / prev daty button
		self.dateNextButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
		self.dateNextButton!.titleLabel?.font = UIFont(name: GoogleIconName, size: 24.0)
		self.dateNextButton!.setTitle(GoogleIcon.ebba, forState:.Normal)
		self.dateNextButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		self.dateNextButton!.showsTouchWhenHighlighted = true
		self.dateNextButton!.addTarget(self, action: "prevNextDateButtonAction:", forControlEvents: .TouchUpInside)
		self.dateBarView!.addSubview(self.dateNextButton!)
		self.datePrevButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
		self.datePrevButton!.titleLabel?.font = UIFont(name: GoogleIconName, size: 24.0)
		self.datePrevButton!.setTitle(GoogleIcon.ebac, forState:.Normal)
		self.datePrevButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		self.datePrevButton!.showsTouchWhenHighlighted = true
		self.datePrevButton!.addTarget(self, action: "prevNextDateButtonAction:", forControlEvents: .TouchUpInside)
		self.dateBarView!.addSubview(self.datePrevButton!)
	}
	
	func setupFilterBar() {
		let effect = UIBlurEffect(style: .Dark)
		self.filterBarView = UIVisualEffectView(effect: effect)
		self.filterBarView!.clipsToBounds = true
		self.navigationController!.view.addSubview(self.filterBarView!)
		
		// filter label
		self.filterLabel = UILabel()
		self.filterLabel!.font = UIFont.systemFontOfSize(14)
		self.filterLabel!.textColor = UIColor.whiteColor()
		self.filterLabel!.textAlignment = NSTextAlignment.Right
		self.filterBarView!.addSubview(self.filterLabel!)
		self.filterLabel!.text = "tofubeats & Electronic"
		
		// filter delete button
		self.filterDeleteButton = UIButton()
		self.filterDeleteButton!.titleLabel?.font = UIFont(name: GoogleIconName, size: 24.0)
		self.filterDeleteButton!.setTitle(GoogleIcon.ebce, forState:.Normal)
		self.filterDeleteButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		self.filterDeleteButton!.addTarget(self, action: "deleteFilterAction:", forControlEvents: .TouchUpInside)
		self.filterBarView!.addSubview(self.filterDeleteButton!)
	}
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		var region = MKCoordinateRegion()
		region.center = self.mapView.userLocation.coordinate
		region.span.latitudeDelta = 0.1
		region.span.longitudeDelta = 0.1
		self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
		self.mapView.userLocation.removeObserver(self, forKeyPath: "location")
	}
	
	func updateDateButton() {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
		
		let transition: CATransition = CATransition()
		transition.duration = 0.25
		transition.type = kCATransitionFade
		self.dateButton!.layer.addAnimation(transition, forKey: nil)
		self.dateButton!.setTitle(dateFormatter.stringFromDate(self.currentDate), forState:.Normal)
	}

	func toggleFilterBar() {
		var frame = self.filterBarView!.frame
		frame.size.height = count(keyword) > 0 || count(category) > 0 ? 36 : 0
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			self.filterBarView!.frame = frame
			self.listView.contentInset = UIEdgeInsetsMake(self.navBarHeight + frame.size.height, 0, self.tabBarHeight + 36, 0)
		})
	}
	
	func toggleEventGlance() {
		let screenBounds = UIScreen.mainScreen().bounds
		let glanceHeight: CGFloat = self.mapView!.selectedAnnotations != nil && self.mapView!.selectedAnnotations.count > 0 ? 120 : 0
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			self.eventGlanceContainer.frame = CGRectMake(0, screenBounds.size.height - glanceHeight - self.tabBarHeight, screenBounds.size.width, glanceHeight)
			self.dateBarView!.hidden = glanceHeight != 0
		})
	}
	
	// MARK: - Database
	
	func refreshDataSource() {
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
		let comps: NSDateComponents? = calendar?.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self.currentDate);
		let fromDate = calendar?.dateFromComponents(comps!)
		let toDate = fromDate!.dateByAddingTimeInterval(60 * 60 * 24)
		
		var query = PFQuery(className: "DemoEvents")
		query.whereKey("date", greaterThanOrEqualTo: fromDate!)
		query.whereKey("date", lessThan: toDate)
		query.findObjectsInBackgroundWithBlock( { (NSArray objects, NSError error) in
			if (error != nil) {
				println("query failed")
			}
			else {
				if let events = objects as? [PFObject] {
					for event in events {
						let location = event["location"] as! PFGeoPoint
						let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
						let pin: MKPointAnnotation = MKPointAnnotation()
						pin.coordinate = coordinate
						pin.title = event["title"] as! String
						pin.subtitle = event["description"] as! String
						self.eventsArray.append(event)
						self.mapView.addAnnotation(pin)
						
					}
				}
			}
		})
	}
	
	// MARK: - Action

	func filterAction(sender: UIBarButtonItem) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("FilterPanel") as! GSFilterPanel
		vc.delegate = self
		let formSheet = MZFormSheetController(viewController: UINavigationController(rootViewController: vc))
		vc.title = "Filter by keyword, category"
		formSheet.presentedFormSheetSize = CGSizeMake(320, 207	+ 44)
		formSheet.transitionStyle = MZFormSheetTransitionStyle.SlideFromTop
		formSheet.shadowRadius = 2.0;
		formSheet.shadowOpacity = 0.3;
		formSheet.shouldDismissOnBackgroundViewTap = true
		formSheet.portraitTopInset = 60.0;
		formSheet.landscapeTopInset = 20.0;
		
		formSheet.willPresentCompletionHandler = { presentedFSViewController in
			vc.keyword = self.keyword
			vc.category = self.category
		}
		self.mz_presentFormSheetController(formSheet, animated: true, completionHandler:nil)
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
			})
	}
	
	func deleteFilterAction(sender: UIButton) {
		self.keyword = ""
		self.category = ""
		self.toggleFilterBar()
	}
	
	func dateButtonAction(sender: UIButton) {
		var datePicker = ActionSheetDatePicker(title: "Select date", datePickerMode: UIDatePickerMode.Date, selectedDate: self.currentDate, doneBlock: { picker, value, index in
			self.currentDate = value as! NSDate
			self.updateDateButton()
			self.refreshDataSource()
			return
			}, cancelBlock: { ActionStringCancelBlock in return	}, origin: self.tabBarController!.view)
		datePicker.showActionSheetPicker()
	}

	func prevNextDateButtonAction(sender: UIButton) {
		let dayTimeInterval: NSTimeInterval = 60 * 60 * 24
		if (sender == self.datePrevButton) {
			self.currentDate = self.currentDate.dateByAddingTimeInterval(-dayTimeInterval)
		} else if (sender == self.dateNextButton) {
			self.currentDate = self.currentDate.dateByAddingTimeInterval(dayTimeInterval)
		}
		self.updateDateButton()
		self.refreshDataSource()
	}
	
	// MARK: - Delegate methods
	
	func dismissSearchView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func filterWithKeyword(keyword: String, andCategory category: String) {
		let transition: CATransition = CATransition()
		transition.duration = 0.25
		transition.type = kCATransitionFade
		self.filterLabel!.layer.addAnimation(transition, forKey: nil)
		self.filterLabel!.text = nil
		if count(keyword) > 0 {
			self.filterLabel!.text = "\(keyword) & \(category)"
			self.keyword = keyword
		} else {
			self.filterLabel!.text = "\(category)"
		}
		self.category = category
		self.toggleFilterBar()
	}

	// MARK: - MKMapViewDelegate
	
	func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
		let leftPoint: CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(0, 0), toCoordinateFromView: mapView!)
		let leftLocation: CLLocation = CLLocation(latitude: leftPoint.latitude, longitude: leftPoint.longitude)
		let rightPoint: CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(0, CGRectGetMaxX(mapView.bounds)), toCoordinateFromView: mapView!)
		let rightLocation: CLLocation = CLLocation(latitude: rightPoint.latitude, longitude: rightPoint.longitude)
		let distance: CLLocationDistance = leftLocation.distanceFromLocation(rightLocation) / 1000
		let numberFormatter = NSNumberFormatter()
		numberFormatter.positiveFormat = "#,##0"
		let distanceString = numberFormatter.stringFromNumber(round(distance))
		self.distanceLabel!.text = distanceString! + "km"
	}
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if annotation is MKUserLocation {
			return nil
		}
		
		let pinIdentifier = "PinAnnotationIdentifier"
		var pinView: MKPinAnnotationView!
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
			pinView.animatesDrop = true
			pinView.canShowCallout = true
			return pinView
		}
		pinView.annotation = annotation
		return pinView
	}
	
	func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
//		let param = ["title": ]
		self.toggleEventGlance()
	}
	
	func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
		self.toggleEventGlance()
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
	
	// MARK: - Segue Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "EventGlanceSegue" {
			self.eventGlance = segue.destinationViewController as? GSEventGlance
		}
	}

	// MARK: - Demo Data
	
	func insertDemoData() {
		let venueA = PFObject(className: "Venues")
		venueA["name"] = "TSUTAYA O-EAST"
		venueA["location"] = PFGeoPoint(latitude: 35.658725, longitude: 139.695608)
		venueA["description"] = "description for TSUTAYA O-EAST"
		venueA.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		let event1 = PFObject(className: "Events")
		event1["title"] = "demo event 1"
		event1["description"] = "description for demo event 1"
		event1["category"] = "Pop"
		event1["date"] = self.dateFromString("2015-04-18 19:00:00")
		event1["venue"] = venueA
		event1.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		let venueB = PFObject(className: "Venues")
		venueB["name"] = "渋谷公会堂"
		venueB["location"] = PFGeoPoint(latitude: 35.664221, longitude: 139.697773)
		venueB["description"] = "description for 渋谷公会堂"
		venueB.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}
		
		let event2 = PFObject(className: "Events")
		event2["title"] = "demo event 2"
		event2["description"] = "description for demo event 2"
		event2["category"] = "Rock"
		event2["date"] = self.dateFromString("2015-04-18 19:00:00")
		event2["venue"] = venueB
		event2.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		let event3 = PFObject(className: "Events")
		event3["title"] = "demo event 3"
		event3["description"] = "description for demo event 3"
		event3["category"] = "Pop"
		event3["date"] = self.dateFromString("2015-04-19 19:00:00")
		event3["venue"] = venueB
		event3.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		let venueC = PFObject(className: "Venues")
		venueC["name"] = "Club Quattro"
		venueC["location"] = PFGeoPoint(latitude: 35.660981, longitude: 139.697604)
		venueC["description"] = "description for Club Quattro"
		venueC.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		let event4 = PFObject(className: "Events")
		event4["title"] = "demo event 4"
		event4["description"] = "description for demo event 4"
		event4["category"] = "Rock"
		event4["date"] = self.dateFromString("2015-04-19 20:00:00")
		event4["venue"] = venueC
		event4.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}

		/*
		let event1 = PFObject(className: "DemoEvents")
		event1["title"] = "demo event 1"
		event1["description"] = "description for demo event 1"
		event1["category"] = "Pop"
		event1["date"] = self.dateFromString("2015-04-18 19:00:00")
		event1["location"] = PFGeoPoint(latitude: 35.658725, longitude: 139.695608)
		event1.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}
		
		let event2 = PFObject(className: "DemoEvents")
		event2["title"] = "demo event 2"
		event2["description"] = "description for demo event 2"
		event2["category"] = "Rock"
		event2["date"] = self.dateFromString("2015-04-18 20:00:00")
		event2["location"] = PFGeoPoint(latitude: 35.661902, longitude: 139.701093)
		event2.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}
		let event3 = PFObject(className: "DemoEvents")
		event3["title"] = "demo event 3"
		event3["description"] = "description for demo event 3"
		event3["category"] = "Pop"
		event3["date"] = self.dateFromString("2015-04-19 19:00:00")
		event3["location"] = PFGeoPoint(latitude: 35.664221, longitude: 139.697773)
		event3.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}
		let event4 = PFObject(className: "DemoEvents")
		event4["title"] = "demo event 4"
		event4["description"] = "description for demo event 4"
		event4["category"] = "Rock"
		event4["date"] = self.dateFromString("2015-04-19 20:00:00")
		event4["location"] = PFGeoPoint(latitude: 35.660981, longitude: 139.697604)
		event4.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
			println("Object has been saved.")
		}
		*/
	}
	
	func dateFromString(dateString: String) -> NSDate {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date: NSDate? = formatter.dateFromString(dateString)
		return date!
	}
}
