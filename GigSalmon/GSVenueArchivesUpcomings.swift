//
//  GSVenueArchivesUpcomings.swift
//  GigSalmon
//
//  Created by tnk on 2015/05/03.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Parse

class GSVenueArchivesUpcomings: UIViewController {

	var venue: PFObject?
	var isArchives: Bool = false
	@IBOutlet weak var collectionView: UICollectionView!
	var currentDate: NSDate! = NSDate()
	var allMonths: [String] = []
	var eventsInMonths = [String: [PFObject]]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
		let comps: NSDateComponents? = calendar?.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self.currentDate)
		let today = calendar?.dateFromComponents(comps!)

		var query = PFQuery(className: "Events")
		query.whereKey("venue", equalTo: venue!)
		if isArchives {
			query.whereKey("date", lessThan: today!)
		} else {
			query.whereKey("date", greaterThanOrEqualTo: today!)
		}
		query.addDescendingOrder("date")
		query.includeKey("venue")
		query.findObjectsInBackgroundWithBlock( { (NSArray objects, NSError error) in
			if error != nil {
				println("query failed")
			} else {
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "MMM, yyyy"
				if let events = objects as? [PFObject] {
					for event in events {
						let eventDate = event["date"] as! NSDate
						let months = dateFormatter.stringFromDate(eventDate)
						if self.eventsInMonths[months] == nil {
							self.eventsInMonths[months] = []
						}
						self.eventsInMonths[months]!.append(event)
						if find(self.allMonths, months) == nil {
							self.allMonths.append(months)
						}
					}
				}
			}
			self.collectionView.reloadData()
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return allMonths.count
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return eventsInMonths[self.allMonths[section]]!.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
		let months: String = self.allMonths[indexPath.section] as String
		let arr: Array = self.eventsInMonths[months]!
		let event: PFObject = arr[indexPath.item] as PFObject
		let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
		nameLabel.text = event["title"] as? String
		let imageView = cell.contentView.viewWithTag(3) as! UIImageView
		let imageFile = event["image"] as! PFFile
		imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
			if error == nil {
				if let imageData = imageData {
					imageView.image = UIImage(data:imageData)
				}
			}
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Section", forIndexPath: indexPath) as! UICollectionReusableView
		let titleLabel = headerView.viewWithTag(1) as! UILabel
		titleLabel.text = self.allMonths[indexPath.section]
		return headerView
	}
	
	// MARK: - UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
	}
}
