//
//  GSEventGlance.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/18.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSEventGlance: UIViewController {

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var venueLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func updateParam(param: NSDictionary) {
		let date: NSDate = param["date"] as! NSDate
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
		self.dateLabel.text = dateFormatter.stringFromDate(date)
		self.titleLabel.text = (param["title"] as! String)
		self.venueLabel.text = (param["venue"] as! String)
		self.descriptionLabel.text = (param["description"] as! String)
	}
}
