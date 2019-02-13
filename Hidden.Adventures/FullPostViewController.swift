//
//  FullPostViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 7/2/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import Alamofire

class FullPostViewController: UIViewController {
    
   
    var adventure: Adventure?
    var favorite: Favorite?

    @IBAction func backButton(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryPic: UIImageView!
    @IBOutlet weak var defaultPic: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIButton!
    
    

    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if (self.favorite == nil) {
            // Favorite not set. Add the favorite.
            sender.tintColor = .red
            let myfavorite = Favorite()
            myfavorite.username = UserSession.shared.getUsername()
            myfavorite.adventureID = adventure?._id
            addFavorite(myfavorite)
        } else {
            // Favorite is set. Remove the favorite.
            sender.tintColor = .lightGray
            removeFavorite(self.favorite!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        // Load the view data
        updateViewData()
        checkFavorite(adventure!)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
// map segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ratingSegue" {
            let destination = segue.destination as! RatingViewController
            destination.adventure = self.adventure
            
        }
        if segue.identifier == "getLocationSegue" {
            let destination = segue.destination as! GetLocationViewController
            destination.adventure = self.adventure
            
        }
        if segue.identifier == "reportPostSegue" {
            let destination = segue.destination as! ReportButtonViewController
            destination.adventure = self.adventure
            
        }
        if (segue.identifier == "usernameButtonSegue") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SidekickProfileViewController
            targetController.sidekickName = username.titleLabel?.text
        }
        if segue.identifier == "openPictureSegue" {
            let destination = segue.destination as! OpenPictureViewController
            destination.adventure = self.adventure
            
        }
    }


    private func updateViewData() {
        username.setTitle(adventure?.author, for: .normal)
        titleLabel.text = adventure?.name
        descLabel.text = adventure?.desc
        categoryPic.image = UIImage(named: "category." + (adventure?.category)!)
        if (adventure?.defaultImage != nil) {
            Utils.setImageView(defaultPic, imageName: (adventure?.defaultImage)!)
        }
        // Set the profile image by getting profile object from server then get the image
        let parameters: Parameters = [
            "username": adventure?.author ?? ""
        ]
        APIClient.getObjectsFromServer(Constants.ProfilesURL, parameters: parameters, ofType: Profile.self) { (profiles, error) in
            if let error = error {
                return print("Get Profile error:", error.localizedDescription)
            }
            let profile = profiles[0]
            if (profile.profileImage != nil) {
                Utils.setImageView(self.profilePic, imageName: profile.profileImage!)
            } else {
                self.profilePic.image = UIImage(named: "profilePic")
            }
        }
    }
    
    private func addFavorite(_ favorite: Favorite) {
        print("Add favorite:", favorite.adventureID!)
        // post the favorite object to the server
        APIClient.postObjectToServer(Constants.FavoritesURL, object: favorite) { (newFavorite, error) in
            if let error = error {
                return print("post favorite error:", error.localizedDescription)
            } else if (newFavorite?._id != nil) {
                self.favorite = newFavorite
            }
        }
    }
    
    private func removeFavorite(_ favorite: Favorite) {
        print("Remove favorite:", favorite.adventureID!)
        let reqURL = Constants.FavoritesURL + "/" + (favorite._id)!
        APIClient.deleteObjectFromServer(reqURL)
        self.favorite = nil
    }
    
    private func checkFavorite(_ adventure: Adventure) {
        // Set query string to find a favorite object for this adventure, if exists
        let parameters: Parameters = [
            "username": UserSession.shared.getUsername(),
            "adventureID": adventure._id!
        ]

        // Get the favorite object from the server, if it exists
        APIClient.getObjectsFromServer(Constants.FavoritesURL, parameters: parameters, ofType: Favorite.self) { (favorites, error) in
            if let error = error {
                return print("Get Profile error:", error.localizedDescription)
            }
            // If no favorites objects returned, this adventure is not favored
            if (favorites.count > 0) {
                self.favorite = favorites[0]
                self.favoriteImage.tintColor = .red
            } else {
                self.favorite = nil
                self.favoriteImage.tintColor = .lightGray
            }
        }
    }


}
