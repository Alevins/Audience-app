//
//  GSEventSearch.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/10.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import CoreLocation

class GSEventSearch: UITableViewController {

	var delegate: AnyObject?
	var keyword: NSString! = ""
	var location: NSString! = ""
	var date: NSDate? = NSDate()

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func showTextSheet(keyword: String) {
		let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SearchTextEdit") as! GSSearchTextEdit
		vc.delegate = self
		let formSheet = MZFormSheetController(viewController: UINavigationController(rootViewController: vc))
		vc.title = keyword
		formSheet.presentedFormSheetSize = CGSizeMake(300, 44 + 44)
		formSheet.transitionStyle = MZFormSheetTransitionStyle.SlideFromTop
		formSheet.shadowRadius = 2.0;
		formSheet.shadowOpacity = 0.3;
		formSheet.shouldDismissOnBackgroundViewTap = true
		formSheet.portraitTopInset = 60.0;
		formSheet.landscapeTopInset = 20.0;
		
		formSheet.willDismissCompletionHandler = { presentedFSViewController in
			let selectedIndexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow()
			if (selectedIndexPath != nil) {
				self.tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
			}
		}
		self.mz_presentFormSheetController(formSheet, animated: true, completionHandler:nil)
	}
	
	func showDateSheet(keyword: String) {
		let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SearchDatePicker") as! GSSearchDatePicker
		vc.delegate = self
		let formSheet = MZFormSheetController(viewController: UINavigationController(rootViewController: vc))
		vc.title = keyword
		formSheet.presentedFormSheetSize = CGSizeMake(320, 216 + 44)
		formSheet.transitionStyle = MZFormSheetTransitionStyle.SlideFromTop
		formSheet.shadowRadius = 2.0;
		formSheet.shadowOpacity = 0.3;
		formSheet.shouldDismissOnBackgroundViewTap = true
		formSheet.portraitTopInset = 60.0;
		formSheet.landscapeTopInset = 20.0;
		
		formSheet.willDismissCompletionHandler = { presentedFSViewController in
			let selectedIndexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow()
			if (selectedIndexPath != nil) {
				self.tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
			}
		}
		self.mz_presentFormSheetController(formSheet, animated: true, completionHandler:nil)
	}

	// MARK: - Action

	@IBAction func cancelAction(sender: AnyObject) {
		let delegate = self.delegate as? GSEventTop
		if ((delegate?.respondsToSelector("dismissSearchSheet")) != nil) {
			delegate!.dismissSearchView()
		}
	}

	@IBAction func searchAction(sender: AnyObject) {
		let alert = UIAlertController(title: "Search Results", message: "Found 20 events", preferredStyle: UIAlertControllerStyle.Alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in

		})
		let showAction = UIAlertAction(title: "Show", style: .Default, handler: { (action:UIAlertAction!) -> Void in
			self.cancelAction(self)
		})
		alert.addAction(cancelAction)
		alert.addAction(showAction)
		presentViewController(alert, animated: true, completion: nil)
	}

	// MARK: - Delegate methods
	
	func updateParam(data: AnyObject) {
		let indexPath = self.tableView.indexPathForSelectedRow()
		switch(indexPath!.row) {
		case 0:	// keyword
			self.keyword = data as? String
			break;
		case 1:	// location
			var str = data as? NSString
			if (str != nil && str!.length > 0) {
				let geocoder = CLGeocoder()
				geocoder.geocodeAddressString(data as! String, completionHandler: { (placemarks, error) -> Void in
					let errorMessage: String?
					if (error != nil || placemarks.count == 0) {
						errorMessage = "Geocode Error"
						let alert = UIAlertController(title: nil, message: "Invalid location name", preferredStyle:.Alert)
						let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
						alert.addAction(cancelAction)
						dispatch_async(dispatch_get_main_queue(), {
							self.presentViewController(alert, animated: true, completion: nil)
						});
					} else {
						self.location = data as? String
					}
				})
			}
			break;
		case 2:	// date
			self.date = data as? NSDate
			break;
		default:
			break;
		}
		dispatch_async(dispatch_get_main_queue(), {
			self.tableView.reloadData()
		});
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
		self.updateCell(cell, atIndexPath: indexPath)
		return cell
	}
	
	func updateCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		var value: NSString!
		switch(indexPath.row) {
		case 0:	// keyword
			value = self.keyword != nil ? self.keyword : ""
			NSLog("keyword:\(value)")
			break;
		case 1:	// location
			value = self.location != nil ? self.location : ""
			NSLog("location:\(value)")
			break;
		case 2:	// date
			let df = NSDateFormatter()
			df.dateStyle = .MediumStyle
			df.timeStyle = .NoStyle
			value = df.stringFromDate(self.date!)
			break;
		default:
			break;
		}
		cell.detailTextLabel?.text = value as String!
	}

	// MARK: - UITableViewDelegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch (indexPath.row) {
		case 0:	// Keyword
			self.showTextSheet("Keyword")
			break;
		case 1:	// Location
			self.showTextSheet("Location")
			break;
		case 2:	// Date
			self.showDateSheet("Date")
			break;
		default:
			break;
		}
	}
}
