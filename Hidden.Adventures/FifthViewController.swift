//
//  FifthViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/22/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import ScalingCarousel
import Alamofire
import ObjectMapper
import Kingfisher

class FifthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

    @IBOutlet weak var scalingCarousel: ScalingCarouselView!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var backgroundPic: UIImageView!
    
    var myProfile: Profile?
    var token: String?
    var isMyProfileStale = true
    var adventures = [Adventure]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //circle around profile picture
        
        profPic.layer.borderWidth = 1
        profPic.layer.masksToBounds = false
        profPic.layer.borderColor = UIColor.black.cgColor
        profPic.layer.cornerRadius = profPic.frame.height/2
        profPic.clipsToBounds = true
        
        
        // carousel stuff
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        
        // Register a handler to reset the profile on logout
        NotificationCenter.default.addObserver(forName: .DidLogout, object: nil, queue: nil, using: handleDidLogoutNotification(_:))

    }
    
    // This gets called every time the view is at the top of the view stack
    override func viewWillAppear(_ animated: Bool) {
        print("FifthViewController viewWillAppear()")
        if (isMyProfileStale) {
            // Set query string to select my own profile
            let parameters: Parameters = [
                "username": UserSession.shared.getUsername()
            ]
            // Get the profile object from the server
            APIClient.getObjectsFromServer(Constants.ProfilesURL, parameters: parameters, ofType: Profile.self) { (profiles, error) in
                if let error = error {
                    return print("Get Profile error:", error.localizedDescription)
                }
                self.myProfile = profiles[0]
                print(profiles.toJSON())
                self.updateViewData()
                // Commenting this line out for now. We will always get the current profile
                // when this page appears
                // self.isMyProfileStale = false
            }
        }
        // Populate the carousel depending on user preference
        let showFavorites = UserDefaults.standard.bool(forKey: Constants.PREF_ProfileShowFavorites)
        if (showFavorites) {
            fetchFavoritesData()
        } else {
            fetchPostData()
        }
    }

    //Handle the logout notification
    func handleDidLogoutNotification(_ notification: Notification) {
        isMyProfileStale = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scalingCarousel.didScroll()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.pool?.currentUser()
        user?.signOut()
        NotificationCenter.default.post(name: .DidLogout, object: nil, userInfo: nil)
        tabBarController!.selectedIndex = 0
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
        if segue.identifier == "editProfileSegue" {
            let destination = segue.destination.children[0] as! EditProfilePageViewController
            destination.myProfile = myProfile
        }
    }
    
    // Called after dismissing the Profile preferences ViewController
    @IBAction func unwindFromProfilePreferancesViewController(_ sender: UIStoryboardSegue) {
        let showFavorites = UserDefaults.standard.bool(forKey: Constants.PREF_ProfileShowFavorites)
        if (showFavorites) {
            fetchFavoritesData()
        } else {
            fetchPostData()
        }
    }
    
    // Update the view after selecting an image
    private func updateViewData() {
        username.text = myProfile?.username
        var locationStr = myProfile?.city ?? ""
        if (myProfile?.city != nil && myProfile?.city != ""
            && myProfile?.state != nil && myProfile?.state != "") {
            locationStr += ", " + (myProfile?.state!)!
        } else if (myProfile?.state != nil) {
            locationStr += (myProfile?.state!)!
        }
        cityState.text = locationStr
        if (myProfile?.profileImage != nil) {
            Utils.setImageView(profPic, imageName: (myProfile?.profileImage)!)
        }
        if (myProfile?.backgroundImage != nil) {
            Utils.setImageView(backgroundPic, imageName: (myProfile?.backgroundImage)!)
        }
    }
    
    // Fetch the adventures that I posted from the server
    private func fetchPostData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = [
            "author": UserSession.shared.getUsername()
        ]
        
        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.AdventuresURL, parameters: parameters, ofType: Adventure.self) { (adventures, error) in
            if let error = error {
                return print("Get posted adventures error:", error.localizedDescription)
            }
            self.adventures = adventures
            for adventure in self.adventures {
                print(adventure.name ?? "")
            }
            DispatchQueue.main.async {
                self.scalingCarousel.reloadData()
                self.scalingCarousel.selectItem(at: IndexPath(row: 0, section:0), animated: true, scrollPosition: [])
                // self.scalingCarousel.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }

    // Fetch my favorite adventures from the server
    private func fetchFavoritesData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = [
            "username": UserSession.shared.getUsername()
        ]
        
        // First get the list of my favorites
        APIClient.getObjectsFromServer(Constants.FavoritesURL, parameters: parameters, ofType: Favorite.self)
        { (favorites, error) in
            if let error = error {
                return print("Get favorites error:", error.localizedDescription)
            }
            
            // Get all the adventure ids out of the favorites array and convert them to
            // a parameter array.
            let ids = favorites.map() {$0.adventureID!}
            let idParams: Parameters? = [
                "$in": ids
            ]
            if (ids.count == 0) {
                return print("No favorites found")
            }

            // Get the adventure objects from the server
            APIClient.getObjectsEncFromServer(Constants.AdventuresFavoritesURL, parameters: idParams, ofType: Adventure.self)
            { (adventures, error) in
                if let error = error {
                    return print("Get favorite adventures error:", error.localizedDescription)
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
}
