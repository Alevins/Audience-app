//
//  GSVenueLocation.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/03.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse

class GSVenueLocation: UIViewController {

	var venue: PFObject?
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if venue != nil {
			let venueLocation = venue!["location"] as! PFGeoPoint
			let location = CLLocation(latitude: venueLocation.latitude, longitude: venueLocation.longitude)
			let pin: MKPointAnnotation = MKPointAnnotation()
			pin.coordinate = CLLocationCoordinate2DMake(venueLocation.latitude, venueLocation.longitude)
			self.mapView.addAnnotation(pin)
			
			var region = self.mapView.region
			region.center = pin.coordinate
			region.span.latitudeDelta = 0.01
			region.span.longitudeDelta = 0.01
			self.mapView.setRegion(self.mapView.regionThatFits(region), animated: false)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Action

	@IBAction func mapAction(sender: AnyObject) {
		let actionSheet = UIAlertController(title: "View with", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
		let appleMapAction = UIAlertAction(title: "Map App", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
			let location = self.venue!["location"] as! PFGeoPoint
			let url = NSURL(string: "http://maps.apple.com/?q=\(location.latitude),\(location.longitude))")
			UIApplication.sharedApplication().openURL(url!)
		})
		actionSheet.addAction(appleMapAction)
		if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
			let googleMapAction = UIAlertAction(title: "Google Maps App", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
				let location = self.venue!["location"] as! PFGeoPoint
				let url = NSURL(string: "comgooglemaps://?q=\(location.latitude),\(location.longitude))")
				UIApplication.sharedApplication().openURL(url!)
			})
			actionSheet.addAction(googleMapAction)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
		actionSheet.addAction(cancelAction)
		self.presentViewController(actionSheet, animated: true, completion: nil)
	}
	
	// MARK: - MKMapViewDelegate
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if annotation is MKUserLocation {
			return nil
		}
		
		let pin = annotation as! MKPointAnnotation
		let pinViewID = "PinAnnotationView"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinViewID) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: pin, reuseIdentifier: pinViewID)
		}
		pinView!.animatesDrop = true
		pinView!.draggable = false
		pinView!.canShowCallout = false
		
		return pinView
	}
}
