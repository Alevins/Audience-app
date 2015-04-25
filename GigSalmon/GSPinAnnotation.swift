//
//  GSPinAnnotation.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/20.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import MapKit
import Parse

class GSPinAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	let event: PFObject?

	init(event aEvent: PFObject) {
		event = aEvent
		title = aEvent["title"] as? String
		subtitle = aEvent["description"] as? String
		let venue: PFObject = aEvent["venue"] as! PFObject
		let location = venue["location"] as! PFGeoPoint
		coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
		super.init()
	}
}
