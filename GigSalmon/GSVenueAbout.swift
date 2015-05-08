//
//  GSVenueAbout.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/03.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Parse

class GSVenueAbout: UIViewController {
	var venue: PFObject?
	@IBOutlet weak var imageView0: UIImageView!
	@IBOutlet weak var imageView1: UIImageView!
	@IBOutlet weak var imageView2: UIImageView!
	@IBOutlet weak var descriptionView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if venue != nil {
			descriptionView.text = venue!["description"] as? String
			self.loadImages()
		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func loadImages() {
		var imageFile = self.venue!["aboutImage0"] as? PFFile
		if imageFile != nil {
			imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error:
				NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						let image = UIImage(data: imageData)
						self.imageView0.image = image
					}
				}
			}
		}
		imageFile = self.venue!["aboutImage1"] as? PFFile
		if imageFile != nil {
			imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error:
				NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						let image = UIImage(data: imageData)
						self.imageView1.image = image
					}
				}
			}
		}
		imageFile = self.venue!["aboutImage2"] as? PFFile
		if imageFile != nil {
			imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error:
				NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						let image = UIImage(data: imageData)
						self.imageView2.image = image
					}
				}
			}
		}
	}
}
