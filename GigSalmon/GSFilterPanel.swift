//
//  GSFilterPanel.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/11.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSFilterPanel: UITableViewController {

	var delegate: AnyObject?
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var pickerView: UIPickerView!
	var categories: [String] = []
	var keyword: String?
	var category: String?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		self.categories = ["no selection"] + appDelegate.eventCategories

		let doneButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		doneButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		doneButton.setTitle(GoogleIcon.ebc2, forState:.Normal)
		doneButton.showsTouchWhenHighlighted = true
		doneButton.addTarget(self, action: "doneAction:", forControlEvents: .TouchUpInside)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
		
		let cancelButton = UIButton(frame: CGRectMake(0, 0, 28, 28))
		cancelButton.titleLabel?.font = UIFont(name: GoogleIconName, size: 28.0)
		cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
		cancelButton.setTitle(GoogleIcon.ebce, forState:.Normal)
		cancelButton.showsTouchWhenHighlighted = true
		cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
		
		if self.keyword != nil && count(self.keyword!) > 0 {
			self.textField.text = self.keyword!
		}
		if self.category != nil && count(self.category!) > 0 {
			var index = find(categories, self.category!)
			if index == nil {
				index = 0
			}
			self.pickerView.selectRow(index!, inComponent: 0, animated: false)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Action
	
	func doneAction(sender: UIBarButtonItem) {
		let delegate = self.delegate as? GSEventTop
//		if ((delegate?.respondsToSelector("filterAction:")) != nil) {
//		if ((delegate?.respondsToSelector("filterAction:andCategory:")) != nil) {
			let selectedIndex = self.pickerView.selectedRowInComponent(0) as Int
			var category: String = ""
			if selectedIndex != 0 {
				category = categories[selectedIndex]
			}
			delegate?.filterWithKeyword(self.textField.text, andCategory: category)
//		}
		self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)
	}
	
	func cancelAction(sender: UIBarButtonItem) {
		self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)
	}

	// MARK: - UIPickerViewDataSource
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categories.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
		return categories[row] as String
	}
	
	// MARK: - UIPickerViewDelegate
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	}

	// MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */
}
