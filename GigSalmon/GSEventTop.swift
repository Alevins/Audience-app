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
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var filterLabel: UILabel!
	@IBOutlet var deleteFilterButton: UIButton!
	var distanceLabel: UILabel?
	var locationManager = CLLocationManager()
	var isListView: Bool = false
	var keyword: String?
	var category: String?
	var startDate: NSDate?
	var currentDate: NSDate?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupBarButtons()
//		self.toggleNavigationBarTranslucent()
		self.listView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
		
		// slider
		let screenBounds = UIScreen.mainScreen().bounds
		let sliderHeight = screenBounds.size.height - 64 - 49 - 36 - 20
		let margin = (screenBounds.size.height - 64 - 49 - 36 - sliderHeight) / 2
		let slider = UISlider(frame: CGRectMake(-230, (screenBounds.size.height + 64 - 49 - 36) / 2 - margin, sliderHeight, 20))
		slider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
		slider.value = 0.5
		slider.addTarget(self, action: "printSliderDate:", forControlEvents: .ValueChanged)
		self.mapView.addSubview(slider)
		
		// date label
		let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
		self.currentDate = NSDate()
		self.startDate = calendar.dateByAddingUnit(.CalendarUnitDay, value: -15, toDate: self.currentDate!, options: nil)!
		self.printSliderDate(slider)

		// filter label
		self.deleteFilterButton.setTitle(GoogleIcon.ebce, forState:.Normal)
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupBarButtons() {
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
	
	func toggleNavigationBarTranslucent() {
		var image: UIImage? = self.isListView ? nil : UIImage()
		var translucent: Bool = !self.isListView
		self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
		self.navigationController?.navigationBar.shadowImage = image
		self.navigationController?.navigationBar.translucent = translucent
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
//			self.toggleNavigationBarTranslucent()
			})
	}
	
	@IBAction func deleteFilterAction(sender: UIButton) {
		let transition: CATransition = CATransition()
		transition.duration = 0.25
		transition.type = kCATransitionFade
		self.filterLabel.layer.addAnimation(transition, forKey: nil)
		self.filterLabel.text = nil
		
		self.deleteFilterButton.hidden = true
	}
	
	func printSliderDate(sender: UISlider) {
		var dateRange = 30 * 24 * 60 * 60
		var interval = NSTimeInterval(Float(dateRange) * sender.value)
		var newDate = self.startDate!.dateByAddingTimeInterval(interval)
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
		self.dateLabel.text = dateFormatter.stringFromDate(newDate)
	}
	
	// MARK: - Delegate methods
	
	func dismissSearchView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func filterWithKeyword(keyword: String, andCategory category: String) {
		let transition: CATransition = CATransition()
		transition.duration = 0.25
		transition.type = kCATransitionFade
		self.filterLabel.layer.addAnimation(transition, forKey: nil)
		self.filterLabel.text = nil
		if count(keyword) > 0 {
			self.filterLabel.text = "\(keyword) & \(category)"
			self.keyword = keyword
		} else {
			self.filterLabel.text = "\(category)"
		}
		self.category = category
		self.deleteFilterButton.hidden = false
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
