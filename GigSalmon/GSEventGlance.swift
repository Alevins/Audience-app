//
//  GSEventGlance.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/18.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Parse

class GSEventGlance: UIViewController {

	var delegate: AnyObject?
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var venueLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func updateParam(param: PFObject) {
		let date: NSDate = param["date"] as! NSDate
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
		self.dateLabel.text = dateFormatter.stringFromDate(date)
		self.titleLabel.text = (param["title"] as? String ?? "")
		let venue = param["venue"] as! PFObject
		self.venueLabel.text = "@" + (venue["name"] as! String)
		self.descriptionLabel.text = (param["description"] as? String ?? "")
	}
	
	// MARK: - Action

	@IBAction func tapAction(sender: AnyObject) {
		let delegate = self.delegate as? GSEventTop
		if ((delegate?.respondsToSelector("showEventDetailView")) != nil) {
			delegate!.showEventDetailView()
		}
	}
}
