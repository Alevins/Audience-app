//
//  GSSelectionMenu.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/27.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSSelectionMenu: UITableViewController {
	var dataSource: [String] = []
	var selectedIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		selectedIndex = NSUserDefaults().integerForKey("selectedDbIndex")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Table view data source

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		self.updateCell(cell, atIndexPath: indexPath)
		
		return cell;
	}
	
	func updateCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		cell.textLabel?.text = dataSource[indexPath.row]
		if indexPath.row == selectedIndex {
			cell.accessoryType = UITableViewCellAccessoryType.Checkmark
		}
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if indexPath.row == 2 {
			return nil
		}
		return indexPath
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.row != selectedIndex {
			let deselected = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
			deselected!.accessoryType = UITableViewCellAccessoryType.None
			let selected = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!)
			selected!.accessoryType = UITableViewCellAccessoryType.Checkmark
			selectedIndex = indexPath.row
			NSUserDefaults().setInteger(selectedIndex, forKey: "selectedDbIndex")
			NSUserDefaults().synchronize()
		}
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}