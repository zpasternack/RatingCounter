### FARatingCounter ###

A simple class to get the count of ratings for an iOS app. This is useful if you want to display
how many ratings your app has, typically near the UI where one could tap to rate your app.


### Usage ###

`FARatingCounter` has a single instance method, `fetchNumberOfRatings`

    func fetchNumberOfRatings(appID: String, completion: @escaping fetchRatingsCompletion)

A default instance is provided via the `defaultCounter` class property.

You'd use it like so:

    FARatingCounter.defaultCounter.fetchNumberOfRatings(appID: appInfo.ID) {
        success, number in
        // Do something with number.
    }


### How's it work? ###

The App Store has a feed which provides, given an app ID, a bunch of information about that app. 
It vends JSON. `FARatingCounter` downloads this data (using `NSURLSession`), and parses it (via 
`NSJSONSerialization`) to get the app review count.

`FARatingCounter` is written in Swift 3. It can also be called from Objective-C.


### Who's responsible for this? ###

I'm Zacharias Pasternack, lead developer for [Fat Apps, LLC](http://www.fat-apps.com). You can check 
out [my blog](http://zpasternack.org), or follow me on [Twitter](https://twitter.com/zpasternack)
or [App.net](https://alpha.app.net/zpasternack).


### License ###

The code is provided under a Modified BSD License. See the LICENSE file for more info.
