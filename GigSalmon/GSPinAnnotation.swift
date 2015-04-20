//
//  GSPinAnnotation.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/20.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import MapKit

class GSPinAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	let event: Dictionary<String, AnyObject?>

	init(event aEvent: Dictionary<String, AnyObject?>) {
		event = aEvent
		title = aEvent["title"] as? String
		subtitle = aEvent["description"] as? String
		coordinate = CLLocationCoordinate2DMake(aEvent["latitude"] as! CLLocationDegrees, aEvent["longitude"] as! CLLocationDegrees)
		super.init()
	}
}
