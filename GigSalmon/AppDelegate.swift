//
//  AppDelegate.swift
//  GigSalmon
//
//  Created by tnk on 2015/04/07.
//  Copyright (c) 2015年 tnk. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var selectedDbIndex: Int = 0
	var eventCategories: Array<String> = ["Rock","Pop", "Folk", "Electronic", "Jazz","World", "Other"]

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Initialize Crashlytics
		Fabric.with([Crashlytics()])
		
		// Initialize Parse
		selectedDbIndex = NSUserDefaults().integerForKey("selectedDbIndex")
		var applicationId = ""
		var clientKey = ""
		switch(selectedDbIndex) {
		case 0:	// GigSalmon_Dev
			applicationId = "K5hqRT1jq7QWfNhqAHZIfPjJJnVbiZT2siyNHFGS"
			clientKey = "Bi0qHXWV36jCx3LPdEEFFOKpGYSW33a7aPLDrWRA"
			break;
		case 1:	// GigSalmon_Staging
			applicationId = "nvnGE3WBNEGWF9UF29EfXNQVjWlX7m34YCbUwj95"
			clientKey = "Y9n82Tmo0wioH1wUVCm5Vj2DwEZh0WgxB8gC8tu8"
			break;
		default:
			break;
		}
		Parse.setApplicationId(applicationId, clientKey: clientKey)
		
		let tabBarController: UITabBarController = self.window!.rootViewController as! UITabBarController
		tabBarController.selectedIndex = NSUserDefaults().integerForKey("selectedTabIndex")

		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

