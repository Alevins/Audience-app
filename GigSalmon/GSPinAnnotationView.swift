//
//  GSPinAnnotationView.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/20.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import MapKit

class GSPinAnnotationView: MKAnnotationView {
	class var size :CGSize {
		return CGSize(width: 36.0, height: 36.0)
	}
	
	override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		
		self.frame = CGRect(origin: self.frame.origin, size: GSPinAnnotationView.size)
		self.canShowCallout = false
		self.annotation = annotation
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		self.image = nil
	}
}
