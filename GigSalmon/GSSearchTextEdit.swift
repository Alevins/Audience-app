//
//  GSSearchTextEdit.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/10.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSSearchTextEdit: UIViewController {

	@IBOutlet var textView: UITextView!
	var delegate: AnyObject?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
	}

	override func viewDidAppear(animated: Bool) {
		self.textView.becomeFirstResponder()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Action

	func doneAction(sender: UIBarButtonItem) {
		let delegate = self.delegate as? GSEventSearch
		if ((delegate?.respondsToSelector("updateparam")) != nil) {
			delegate!.updateParam(textView.text)
		}
		self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)
	}

	func cancelAction(sender: UIBarButtonItem) {
		self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)
	}
}
