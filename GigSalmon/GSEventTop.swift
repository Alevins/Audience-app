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
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var listView: UITableView!
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

		self.listView.contentInset = UIEdgeInsetsMake(self.navBarHeight + filterBarHeight, 0, self.tabBarHeight + dateBarHeight, 0)
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
