//
//  FirstViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 2/15/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import ScalingCarousel
import CoreLocation
import Alamofire


class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    // MARK: Properties
    
    // Constants miles to meters
    // ["1Mi", "5Mi", "10Mi", "25Mi", "50Mi"]
    let milestoMeters = [1161, 8000, 16100, 40200, 80500]
    
    var feedSettingToggle = false
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var shouldResetMap: Bool = true
  
    var adventures = [Adventure]()
    var sidekickNames: [String]?
  
    @IBOutlet weak var scalingCarousel: ScalingCarouselView!
    
    @IBAction func newPost(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(newPostCont), userInfo: nil, repeats: false)
    }
    
    @objc func newPostCont() {
        tabBarController!.selectedIndex = 2
    }

    // Refresh the carousel from the server
    @IBAction func refreshButton(_ sender: Any) {
        // Fetch data from the server and reload the carousel
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        
        // Always reset this on app startup
        UserDefaults.standard.set(false, forKey: Constants.PREF_FeedSidekicksOnly)
        
        // Sets up location manager (constant gps)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        currentLocation = nil
        
        NotificationCenter.default.addObserver(forName: .DidLogout, object: nil, queue: nil, using: handleDidLogoutNotification(_:))

        self.refresh()   
    }
    
    // This gets called every time the view is at the top of the view stack
    override func viewWillAppear(_ animated: Bool) {
        print("FirstViewController viewWillAppear()")
        shouldResetMap = true
        locationManager.startUpdatingLocation()
    }

    // Called after dismissing the EditFeed ViewController
    @IBAction func unwindFromEditFeedViewController(_ sender: UIStoryboardSegue) {
        fetchData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adventures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adventureCell", for: indexPath) as? AdventureCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of AdventureCollectionViewCell")
        }
        // Fetches the appropriate adventure for the data source layout.
        let adventure = adventures[indexPath.row]

        Utils.setImageView(cell.adventureImage, imageName: adventure.defaultImage!)
        cell.adventureName.text = adventure.name
        cell.adventureAuthor.text = "@" + adventure.author!
        if (adventure.ratingCount != 0) {
            cell.adventureRating.rating = adventure.rating! / Double(adventure.ratingCount!)
        } else {
            cell.adventureRating.rating = 0
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       scalingCarousel.didScroll()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullPostSegue" {
            let destination = segue.destination as! FullPostViewController
            if let cell = sender as? UICollectionViewCell, let indexPath = scalingCarousel.indexPath(for: cell) {
                let adventure = adventures[indexPath.row]
                destination.adventure = adventure
            }
        }
    }

    // MARK: - Private Functions
    
    //Handle the logout notification
    func handleDidLogoutNotification(_ notification: Notification) {
        refresh()
    }
    
    

    // This method forces either a login screen sequence or gets the acccess token
    private func refresh() {
        // This is the point where Cognito will pop a login page if user is not logged in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.pool?.currentUser()
        user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                print("in refresh() continueOnSuccessWith")
                UserSession.shared.getToken()
                self.fetchData()
                UserSession.shared.checkRegisterNewUser()
            })
            return nil
        }
    }
    
    private func fetchData() {
        // Populate the carousel depending on user preference
        let showSidekicksOnly = UserDefaults.standard.bool(forKey: Constants.PREF_FeedSidekicksOnly)
        if (showSidekicksOnly) {
            fetchSidekicksOnlyData()
        } else {
            fetchAllData()
        }
    }
    
    // Fetch the table data from the server
    private func fetchAllData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let distanceIndex = UserDefaults.standard.integer(forKey: Constants.PREF_FeedDistanceIndex)
        
        // Set query string to select profiles
        let parameters: Parameters? = [
            "longitude": currentLocation?.coordinate.longitude as Any,
            "latitude": currentLocation?.coordinate.latitude as Any,
            "distance": milestoMeters[distanceIndex]
        ]

        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.AdventuresGeoURL, parameters: parameters, ofType: Adventure.self) { (adventures, error) in
            if let error = error {
                return print("Get adventures error:", error.localizedDescription)
            }
            self.adventures = adventures
            for adventure in self.adventures {
                print(adventure.name ?? "")
            }
            DispatchQueue.main.async {
                self.scalingCarousel.reloadData()
            }
        }
    }
    
    // Fetch the "sidekicks only" table data from the server
    private func fetchSidekicksOnlyData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
        // Set query string to select sidekicks by username
        let parameters: Parameters? = ["username": UserSession.shared.getUsername()]
        
        // Get the sidekick objects from the server
        APIClient.getObjectsFromServer(Constants.SidekicksURL, parameters: parameters, ofType: Sidekick.self) { (sidekicks, error) in
            if let error = error {
                return print("Get sidekicks error:", error.localizedDescription)
            }
            // Collect the sidekick names into a simple String array for easier processing later
            let sidekickNames = sidekicks.map({ (sidekick) -> String in (sidekick.sidekickName!) })
            self.sidekickNames = sidekickNames

            let distanceIndex = UserDefaults.standard.integer(forKey: Constants.PREF_FeedDistanceIndex)
            
            // Set query string to select adventures based on the user's sidekick list
            let parameters: Parameters? = [
                "longitude": self.currentLocation?.coordinate.longitude as Any,
                "latitude": self.currentLocation?.coordinate.latitude as Any,
                "distance": self.milestoMeters[distanceIndex],
                "sidekicks": self.sidekickNames as Any
            ]
            
            // Get the adventure objects from the server
            APIClient.getObjectsFromServer(Constants.AdventuresGeoSidekicksOnlyURL, parameters: parameters, ofType: Adventure.self) { (adventures, error) in
                if let error = error {
                    return print("Get adventures error:", error.localizedDescription)
                }
                self.adventures = adventures
                
                // Reload the carousel
                DispatchQueue.main.async {
                    self.scalingCarousel.reloadData()
                }
            }
        }
    }
    
}

extension FirstViewController: CLLocationManagerDelegate {
    
    // Finds current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (shouldResetMap) {
            let latestLocation: CLLocation = locations[locations.count - 1]
            self.currentLocation = latestLocation
            print("FirstViewController locations = \(latestLocation.coordinate.latitude) \(latestLocation.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            shouldResetMap = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("I got a location error")
    }
}

