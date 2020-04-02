//
//  ViewController.swift
//  Plant3r
//
//  Created by G-Bear on 2020-03-31.
//  Copyright © 2020 G-Bear. All rights reserved.
//

// https://github.com/google/google-api-objectivec-client-for-rest/issues/292
// https://www.youtube.com/watch?v=shctaaILCiU
// https://developers.google.com/sheets/api/guides/values

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
	@IBOutlet var theSwitch:UISwitch!
	let sheetID_NoFrillsBears = "1nKi4FC6qb0hsPVtyfTUnQDIYH-ozbaQ2ranuJGf6sjg"
	let sheetID_Plant3r = "1SxHljprXomeMNmUoT1Yd_JW3CjdZ3-GW9kzGi-3DCls"
	let range_NoFrillsBears = "Sheet1!A1:A6"
	let range_Plant3r = "Plants per Container size!A2:B68"
	
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
	{
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
			
			
			let service = GTLRSheetsService()
			service.apiKey = "AIzaSyAbGCKb_jYBD307gFXI5sVcqAeaQcGUMDY"
		
			var sheetID = sheetID_NoFrillsBears
			var range = range_NoFrillsBears
			if theSwitch!.isOn {
				sheetID = sheetID_Plant3r
				range = range_Plant3r
			}
			
			// NoFrills Bears sheet:
			let getValuesQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId:sheetID, range:range)
			service.executeQuery(getValuesQuery) { (ticket:GTLRServiceTicket, objects:Any?, err:Error?) in
				print("555")
				print("\(err)")
				
				if let gtlrObject = objects as? GTLRObject {
					if let gtlrJSON = gtlrObject.json {
						
						
						print("777")
					}
					
					print("666")
				}
			}

			print("3")
		} else {
            print("ERROR ::\(error.localizedDescription)")
        }
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if let user = GIDSignIn.sharedInstance()?.currentUser {
			print("1")
		}else{
			print("2")
		}
		
		//GIDSignIn.sharedInstance().presentingViewController = self
	}
	
	@IBAction func buttonClicked(sender:UIButton)
	{
		GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().clientID = "577252377971-756bnoh8r0f88esbl8fpjkmcn8srra95.apps.googleusercontent.com"
		
		GIDSignIn.sharedInstance().signIn()
	}
}

