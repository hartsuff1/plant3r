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

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet var tableFoodKind:UITableView!
	@IBOutlet var tableFoodName:UITableView!
	@IBOutlet var textfieldSize:UITextField!
	@IBOutlet var buttonTellMeWhatICanPlant:UIButton!
	
	let sheetID = "1SxHljprXomeMNmUoT1Yd_JW3CjdZ3-GW9kzGi-3DCls"
	let range = "Plants per Container size!A2:B68"
	var arrFoodKinds = [String]()						// values for the table on the left
	var arrFoodNamesOfSelectedFoodKind = [String]()		// values for the table on the right
	var chosenFoodKind = ""								// choice made on left table
	var chosenFoodNameOfSelectedFoodKind = ""			// choice made on right table
	var arrSheetValues:NSArray!
	var sheetValueC4 = 0								// number of NC5 containers retrieved from the spreadsheet
	var sheetValueD4 = 0								// number of NC10 containers retrieved from the spreadsheet
	var sheetValueE4 = 0								// number of NC15 containers retrieved from the spreadsheet

	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if let tfSize = self.textfieldSize {
			tfSize.text = "144"
		}
	
		self.callGoogleSheet("A2:B68") { (arrValues:NSArray) in
			self.arrSheetValues = arrValues		// retain this while app is alive
			self.arrFoodKinds.removeAll()

			for value in arrValues {
				if let kindAndName = value as? NSArray {
					if let kind = kindAndName.firstObject as? String {
						if self.arrFoodKinds.firstIndex(of:kind) == .none {
							self.arrFoodKinds.append(kind)
						}
					}
				}
			}

			// select the first food kind (on the main thread)
			DispatchQueue.main.async {
				self.tableFoodKind.reloadData()
				self.tableFoodKind.selectRow(at:IndexPath.init(row:0, section:0), animated:false, scrollPosition:.top)
			}
		}

		// get the values for C4, D4, and E4 from the spreadsheet (NC5, NC10, and NC15)
		self.callGoogleSheet("C4:E4") { (arrValues:NSArray) in
			print("got c4")
		}
		self.callGoogleSheet("D4:D4") { (arrValues:NSArray) in
			print("got d4")
		}
		self.callGoogleSheet("E4:E4") { (arrValues:NSArray) in
			print("got e4")
		}
	}
	
	// downloads the specified range of the Google Sheet and calls the completionBlock supplied with the result as an NSArray
	// see https://fluffy.es/what-is-escaping-closure/ on the meaning of "@escaping"
	func callGoogleSheet(_ cellRange:String, completionBlock:@escaping (_ arr:NSArray) -> ())
	{
		let service = GTLRSheetsService()
		service.apiKey = "AIzaSyAbGCKb_jYBD307gFXI5sVcqAeaQcGUMDY"
		
		let range = "Plants per Container size!\(cellRange)"
		let getValuesQuery = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId:sheetID, range:range)
		service.executeQuery(getValuesQuery) { (ticket:GTLRServiceTicket, objects:Any?, err:Error?) in
			// if we get here, objects will contain whatever Google returned to us
			if let gtlrObject = objects as? GTLRObject {
				if let gtlrJSON = gtlrObject.json {
					if let values = gtlrJSON["values"] {
						if let arrValues = values as? NSArray {
							// call the completion block with the results as an NSArray
							completionBlock(arrValues)
						}
					}
				}
			}
		}
	}

	@IBAction func buttonTellMeWhatICanPlantClicked(sender:UIButton)
	{
		// take square footage entered by user and multiply it by 144
		if let tfSize = self.textfieldSize {
			if let tfSizeText = tfSize.text {
				if let nSize = Int32(tfSizeText)  {
					let area = nSize * 144
					
					let NC5 = area / 225
					let NC10 = area / 400
					let NC15 = area / 500
				
					print("X")
				}
			}
		}
	}

	// MARK: - Google SignIn stuff (which isn't even necessary for this app)
	
	// Called when SignIn button is clicked but this isn't even necessary.
	// You don't need to sign in to query the Google Sheet.
	@IBAction func buttonSignInClicked(sender:UIButton)
	{
		if let _ = GIDSignIn.sharedInstance()?.currentUser {
			print("User is signed in")
		}else{
			print("User is not signed in")

			// hides the keyboard (if any)
			textfieldSize.resignFirstResponder()

			// displays the Google Signin page
			GIDSignIn.sharedInstance().delegate = self
			GIDSignIn.sharedInstance().uiDelegate = self
			GIDSignIn.sharedInstance().clientID = "577252377971-756bnoh8r0f88esbl8fpjkmcn8srra95.apps.googleusercontent.com"
			GIDSignIn.sharedInstance().signIn()
		}
	}

	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
	{
		// hides the keyboard (if any)
		textfieldSize.resignFirstResponder()

		if (error == nil) {
            // Perform any operations on signed in user here.
			print("UserID = \(user.userID!)")
			print("UserToken = \(user.authentication.idToken!)")
			print("Full Name = \(user.profile.name!)")
			print("Given name = \(user.profile.givenName!)")
			print("Family name = \(user.profile.familyName!)")
			print("Email = \(user.profile.email!)")
		} else {
            print("ERROR ::\(error.localizedDescription)")
        }
	}
	
	// MARK: - UITableViewDelegate and DataSource methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if tableView == tableFoodKind {
			return arrFoodKinds.count
		}
		if tableView == tableFoodName {
			return arrFoodNamesOfSelectedFoodKind.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		var ret = tableView.dequeueReusableCell(withIdentifier:"cell")
		if ret == nil {
			ret = UITableViewCell.init(style:.default, reuseIdentifier:"cell")
		}
		
		if tableView == tableFoodKind {
			if let x = ret?.textLabel {
				x.text = arrFoodKinds[indexPath.row]
			}
		}
		if tableView == tableFoodName {
			if let x = ret?.textLabel {
				x.text = arrFoodNamesOfSelectedFoodKind[indexPath.row]
			}
		}

		return ret!
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		textfieldSize.resignFirstResponder()
		
		if tableView == tableFoodKind {
			self.chosenFoodKind = arrFoodKinds[indexPath.row]
			arrFoodNamesOfSelectedFoodKind.removeAll()
			
			if let arrValues = self.arrSheetValues {
				for value in arrValues {
					if let kindAndName = value as? NSArray {
						if let kind = kindAndName.firstObject as? String {
							if kind == self.chosenFoodKind {
								if let name = kindAndName.lastObject as? String {
									self.arrFoodNamesOfSelectedFoodKind.append(name)
								}
							}
						}
					}
				}

				// select the first food kind
				self.tableFoodName.reloadData()
				self.tableFoodName.selectRow(at:IndexPath.init(row:0, section:0), animated:false, scrollPosition:.top)

				// the 'Tell me what I can plant' button is disabled until something
				// is selected in the Food Name table
				self.buttonTellMeWhatICanPlant.isEnabled = true
			}
		}
		if tableView == tableFoodName {

		}
	}
}

