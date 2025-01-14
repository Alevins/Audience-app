//
//  GSMenuTop.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/07.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSMenuTop: UITableViewController {

	@IBOutlet weak var versionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let version: AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
		self.versionLabel.text = "Version \(version)"
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		NSUserDefaults().setInteger(3, forKey: "selectedTabIndex")
		NSUserDefaults().synchronize()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

    // MARK: - UITableViewDataSource

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		self.updateCell(cell, atIndexPath: indexPath)

		return cell;
	}
	
	func updateCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		var title: NSString
		var thumb: UIImage
		switch (indexPath.row) {
		case 0:	// account
			title = "Account"
			thumb = UIImage(named:"MenuAccount")!
			break;
		case 1:	// ticket
			title = "Your Tickets"
			thumb = UIImage(named:"MenuTicket")!
			break;
		case 2:	// setting
			title = "Settings"
			thumb = UIImage(named:"MenuSettings")!
			break;
		case 3:	// guide
			title = "User Guide"
			thumb = UIImage(named:"MenuGuide")!
			break;
		default:
			title = ""
			thumb = UIImage()
			break;
		}
		cell.textLabel?.text = title as String
		cell.imageView?.image = thumb
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if indexPath.row == 2 {
			return indexPath
		}
		return nil
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == 2 {
			self.performSegueWithIdentifier("ShowDBSelectionSegue", sender: self)
		}
	}
	
}
