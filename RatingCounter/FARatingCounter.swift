//
//  FARatingCounter.swift
//
//  Created by Zacharias Pasternack on 4/28/15.
//  Copyright (c) 2015-2017 FatApps, LLC. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// * Neither the name Fat Apps, LLC nor the
// names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import Foundation

@objc class FARatingCounter: NSObject {
	
	class var defaultCounter: FARatingCounter {
		return defaultInstance
	}
	
	// Ideally this function would pass an Int?, but that makes it incompatible with Obj-C.
	// Instead, pass Bool for success, Int for number (which will be zero if !success).
	typealias fetchRatingsCompletion = (Bool, Int) -> ()
	
	func fetchNumberOfRatings(appID: String, completion: @escaping fetchRatingsCompletion) {
		
		let appStoreURL = URL(string: "https://itunes.apple.com/lookup?id=\(appID)")
		let task = URLSession.shared.dataTask(with: appStoreURL!, completionHandler: { (data, response, error) in
			
			var gotResult = false
			var ratingsCount = 0
			
			if error == nil && data != nil,
				let jsonResult = (try? JSONSerialization.jsonObject(with: data!, options:[])) as? NSDictionary,
				let results = jsonResult["results"] as? NSArray,
				results.count > 0,
				let result = results[0] as? NSDictionary,
				let numberOfTimes = result["userRatingCountForCurrentVersion"] as? Int
			{
				// Got it!
				gotResult = true
				ratingsCount = numberOfTimes
			}
			
			DispatchQueue.main.async {
				completion(gotResult, ratingsCount)
			}
		})
		
		task.resume()
	}
	
	private static let defaultInstance = FARatingCounter()
}
