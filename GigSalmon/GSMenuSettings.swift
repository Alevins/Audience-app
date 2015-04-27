//
//  GSMenuSettings.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/27.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSMenuSettings: UITableViewController {

	let dbSelectionMenu = ["GigSalmon_Dev", "GigSalmon_Staging", "GigSalmon_Production"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - UITableViewDataSource

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		self.updateCell(cell, atIndexPath: indexPath)
		
		return cell;
	}
	
	func updateCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		var title: NSString
		var detail: NSString
		switch (indexPath.row) {
		case 0:	// DB Selection
			title = "DB Selection"
			let selectedDB = NSUserDefaults().integerForKey("selectedDbIndex")
			detail = dbSelectionMenu[selectedDB]
			break;
		default:
			title = ""
			detail = ""
			break;
		}
		cell.textLabel?.text = title as String
		cell.detailTextLabel?.text = detail as String
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row == 0 {
			self.performSegueWithIdentifier("ShowSelectionMenuSegue", sender: self)
		}
	}
	
	// MARK: - Segue Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowSelectionMenuSegue" {
			let selectionMenu = segue.destinationViewController as! GSSelectionMenu
			selectionMenu.dataSource = dbSelectionMenu
		}
	}
}
