//
//  GSShowImage.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/10.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit

class GSShowImage: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	var image: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if image != nil {
			imageView.image = image
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    // MARK: - Action

	@IBAction func tapAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
