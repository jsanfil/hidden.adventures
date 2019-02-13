//
//  SidekickProfileViewController.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-07-01.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Alamofire
import ScalingCarousel

class SidekickProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var profile: Profile?
    var sidekickName: String?
    var adventures = [Adventure]()
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var scalingCarousel: ScalingCarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        // carousel stuff
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        // If coming from profile page, we got the profile data already
        if (profile != nil) {
            updateViewData()
            fetchData()
        } else {
            // Set query string to fetch the sidekick's profile from server
            let parameters: Parameters = [
                "username": self.sidekickName ?? ""
            ]
            // Get the profile object from the server
            APIClient.getObjectsFromServer(Constants.ProfilesURL, parameters: parameters, ofType: Profile.self) { (profiles, error) in
                if let error = error {
                    return print("Get Profile error:", error.localizedDescription)
                }
                self.profile = profiles[0]
                print(profiles.toJSON())
                self.updateViewData()
                self.fetchData()
                }
        }

    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
  
    
    // Update the view after selecting an image
    private func updateViewData() {
        username.text = profile?.username
      
        var locationStr = profile?.city ?? ""
        if (profile?.city != nil && profile?.city != ""
            && profile?.state != nil && profile?.state != "") {
            locationStr += ", " + (profile?.state!)!
        } else if (profile?.state != nil) {
            locationStr += (profile?.state!)!
        }
        cityState.text = locationStr

        if (profile?.profileImage != nil) {
            Utils.setImageView(profilePic, imageName: (profile?.profileImage)!)
        } else {
            profilePic.image = UIImage(named: "profilePic")
        }
        if (profile?.backgroundImage != nil) {
            Utils.setImageView(backgroundPic, imageName: (profile?.backgroundImage)!)
        } else {
            backgroundPic.image = UIImage(named: "sunset-1")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adventures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownCell", for: indexPath) as? OwnCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of AdventureCollectionViewCell")
        }
        // Fetches the appropriate adventure for the data source layout.
        let adventure = adventures[indexPath.row]
        
        Utils.setImageView(cell.adventureImage, imageName: adventure.defaultImage!)
        cell.adventureTitle.text = adventure.name
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

    // Fetch the table data from the server
    private func fetchData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = [
            "author": (profile?.username)!
        ]
        
        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.AdventuresSidekicksURL, parameters: parameters, ofType: Adventure.self) { (adventures, error) in
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

}
