//
//  ViewController.swift
//  Plant3r
//
//  Created by G-Bear on 2020-03-31.
//  Copyright © 2020 G-Bear. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
	{
		print("X")
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		//GIDSignIn.sharedInstance().presentingViewController = self
	}
	
	@IBAction func buttonClicked(sender:UIButton)
	{
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
		GIDSignIn.sharedInstance().clientID = "577252377971-756bnoh8r0f88esbl8fpjkmcn8srra95.apps.googleusercontent.com"
		
		GIDSignIn.sharedInstance().signIn()
	}
}

