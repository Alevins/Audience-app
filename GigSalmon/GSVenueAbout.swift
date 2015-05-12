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
	
	var delegate: AnyObject?
	var venue: PFObject?
	@IBOutlet weak var imageView0: UIImageView!
	@IBOutlet weak var imageView1: UIImageView!
	@IBOutlet weak var imageView2: UIImageView!
	@IBOutlet weak var descriptionView: UITextView!
	let googleApiKey = "AIzaSyD6elEy3SUi2T4k41ok5pMsWRpGme4uURI"

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if venue != nil {
			descriptionView.text = venue!["description"] as? String
			self.loadImage("aboutImage0", videoColumnName: "aboutVideo0", forImageView: self.imageView0)
			self.loadImage("aboutImage1", videoColumnName: "aboutVideo1", forImageView: self.imageView1)
			self.loadImage("aboutImage2", videoColumnName: "aboutVideo2", forImageView: self.imageView2)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func loadImage(columnName: String, videoColumnName videoColumn: String, forImageView imageView: UIImageView) {
		let imageFile = self.venue![columnName] as? PFFile
		if imageFile != nil {
			imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error:
				NSError?) -> Void in
				if error == nil {
					if let imageData = imageData {
						let image = UIImage(data: imageData)
						imageView.image = image
					}
				}
			}
		} else {
			let videoId = venue![videoColumn] as? String
			if videoId != nil {
				let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videoId!)&key=\(googleApiKey)&part=snippet,contentDetails,statistics,status"
				let url = NSURL(string: urlString)
				var request = NSMutableURLRequest(URL: url!)
				request.HTTPMethod = "GET"
				var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
					if (error == nil) {
						dispatch_async(dispatch_get_main_queue(), {
							self.loadVideoThumbWithData(data, andResponse: response, forImageView: imageView)
						})
					} else {
						println(error)
					}
				})
				task.resume()
			}
		}
	}
	
	func loadVideoThumbWithData(data: NSData, andResponse response: NSURLResponse, forImageView imageView: UIImageView) {
		let httpURLResponse = response as! NSHTTPURLResponse
		let statusCode = httpURLResponse.statusCode
		let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
		if statusCode == 200 {
			let items = jsonDict["items"] as! NSArray
			let item = items[0] as! NSDictionary
			let mediumUrlString = item.valueForKeyPath("snippet.thumbnails.medium.url") as! String
			imageView.sd_setImageWithURL(NSURL(string: mediumUrlString))
			let tag = imageView.tag
			self.view.viewWithTag(tag + 100)!.hidden = false
		}
	}
	
	// MARK: - Action

	@IBAction func thumbTapAction(sender: UITapGestureRecognizer) {
		let tag = sender.view!.tag
		if self.view.viewWithTag(tag + 100)!.hidden {
			let imageFile = self.venue!["aboutImage\(tag - 10)"] as? PFFile
			if imageFile != nil {
				let sourceView = sender.view as! UIImageView
				let sourceImage = sourceView.image
				(delegate as! GSVenueDetail).showImageViewWithImage(sourceImage!)
			}
		} else {
			let columnName = "aboutVideo\(tag - 10)"
			let videoId = venue![columnName] as? String
			if videoId != nil {
				(delegate as! GSVenueDetail).showVideoViewWithId(videoId!)
			}
		}
	}
	
	@IBAction func showWebSiteAction(sender: AnyObject) {
		let siteUrl = venue!["siteUrl"] as? String
		if siteUrl != nil {
			(delegate as! GSVenueDetail).showWebViewWithUrl(siteUrl!)
		}
	}
}
