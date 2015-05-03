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
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if venue != nil {
			descriptionLabel.text = venue!["description"] as? String
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
