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
	@IBOutlet var gradientView: UIView!
	@IBOutlet var aboutButton: UIButton!
	@IBOutlet var locationButton: UIButton!
	@IBOutlet var archivesButton: UIButton!
	@IBOutlet var upcomingsButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let gradientLayer: CAGradientLayer = CAGradientLayer()
		gradientLayer.frame = self.gradientView.bounds
		gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
		self.gradientView.layer .insertSublayer(gradientLayer, atIndex: 0)

		if venue != nil {
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
}
