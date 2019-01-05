//
//  ViewController.swift
//  RatingsGetter
//
//  Created by Zacharias Pasternack on 4/8/16.
//  Copyright © 2016 FatApps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	struct AppInfo {
		let ID: String
		let name: String
		var ratings: Int?
	}
	
	fileprivate var ratings: [AppInfo] = [
		AppInfo(ID: "391439366", name:"PuzzleTiles", ratings: nil),
		AppInfo(ID: "568903335", name:"1Password", ratings: nil),
		AppInfo(ID: "327630330", name:"Dropbox", ratings: nil),
		AppInfo(ID: "281796108", name:"Evernote", ratings: nil),
		AppInfo(ID: "506003812", name:"Paper", ratings: nil),
		AppInfo(ID: "NOT_A_REAL_APP", name:"Not A Real App", ratings: nil)
	]
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ratings.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let aCell = UITableViewCell(style: .value1, reuseIdentifier: "RatingCell")
		let appInfo = ratings[indexPath.row]
		aCell.textLabel?.text = "\(appInfo.name) (\(appInfo.ID))"
		
		if let count = appInfo.ratings {
			aCell.detailTextLabel!.text = String(count)
			aCell.accessoryView = nil
		}
		else {
			FARatingCounter.default.fetchNumberOfRatings(appID: appInfo.ID) {
				(success, number) in

				self.ratings[indexPath.row].ratings = success ? number : 0
				tableView.cellForRow(at: indexPath)?.accessoryView = nil
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
			
			let spinner = UIActivityIndicatorView(style: .gray)
			spinner.startAnimating()
			aCell.accessoryView = spinner
		}
		
		return aCell
	}
}
