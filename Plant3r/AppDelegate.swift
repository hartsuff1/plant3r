//
//  AppDelegate.swift
//  Plant3r
//
//  Created by G-Bear on 2020-03-31.
//  Copyright © 2020 G-Bear. All rights reserved.
//

// Google Sheets API KEY = "AIzaSyAbGCKb_jYBD307gFXI5sVcqAeaQcGUMDY"
// Google Sheets Client ID = "577252377971-756bnoh8r0f88esbl8fpjkmcn8srra95.apps.googleusercontent.com"	or "577252377971-756bnoh8r0f88esbl8fpjkmcn8srra95.apps.googleusercontent.com"

// The client ID can always be accessed from Credentials in APIs & Services
// OAuth is limited to 100 sensitive scope logins until the OAuth consent screen is published. This may require a verification process that can take several days.


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		// Override point for customization after application launch.
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
	{
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
	{
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}

