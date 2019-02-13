//
//  FourthViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/21/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Alamofire

class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // List of accounts - data from the server
    var profiles = [Profile]()
    var sidekicks = [Sidekick]()
    var sidekickNames = [String]()
    var searchController: UISearchController!

    @IBOutlet weak var accountsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self

        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        accountsTableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        self.definesPresentationContext = true
        
        // Fetch the profiles and sidekicks from the server
        fetchSidekicks()
        fetchData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "accountsCell"
        
        guard let cell =
            accountsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            AccountsTableViewCell else {
                fatalError("The dequeued cell is not an instance of AccountsTableViewCell")
        }
        
        let profile = profiles[indexPath.row]
   
        var locationStr = profile.city ?? ""
        if (profile.city != nil && profile.city != ""
            && profile.state != nil && profile.state != "") {
            locationStr += ", " + profile.state!
        } else if (profile.state != nil) {
            locationStr += profile.state!
        }
        cell.locationLabel.text = locationStr
        if (profile.profileImage != nil) {
            Utils.setImageView(cell.profilePicImage, imageName: profile.profileImage!)
        } else {
            cell.profilePicImage.image = UIImage(named: "profilePic")
        }

      // circle prof pic
        cell.profilePicImage.layer.borderWidth = 1
        cell.profilePicImage.layer.masksToBounds = false
        cell.profilePicImage.layer.borderColor = UIColor.black.cgColor
        cell.profilePicImage.layer.cornerRadius = cell.profilePicImage.frame.height/2
        cell.profilePicImage.clipsToBounds = true
 
        cell.adventureNumberLabel.text = "100 adventures"
        cell.usernameLabel.text = profile.username

        // Set button for either an existing sidekick or not
        cell.sidekickBtn.tag = indexPath.row
        cell.sidekickBtn.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        if (profile.isSidekick)! {
            cell.sidekickBtn.setTitle("Remove Sidekick", for: .normal)
            cell.sidekickBtn.setTitleColor(.black, for: .normal)
            cell.sidekickBtn.tintColor = .black
            cell.sidekickBtn.backgroundColor = .myBeige
            
        } else {
            cell.sidekickBtn.setTitle("Add Sidekick", for: .normal)
            cell.sidekickBtn.setTitleColor(.myDarkGreen, for: .normal)
            cell.sidekickBtn.tintColor = .myDarkGreen
            cell.sidekickBtn.backgroundColor = nil
        }
       
        return cell
    }
    
    // Handle sidekick button press in the cell
    @objc func buttonSelected(sender: UIButton){
        let profile = profiles[sender.tag]
        
        // Check if you selected yourself as a sidekick. Don't let that happen
        if (profile.username == UserSession.shared.getUsername()) {
            let alert = UIAlertController(title: "Selected Sidekick", message: "We know you are lonely, but you can't be your own sidekick. Invite some friends to join.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                print("Error: selected self as sidekick")
            }))
            self.present(alert, animated: true)
            return
        }
        
        if (profile.isSidekick)! {
            profile.isSidekick = false
            let sidekick = self.sidekicks.first { $0.sidekickName == profile.username }
            removeSidekick(sidekick!)
            sender.setTitle("Add Sidekick", for: .normal)
            sender.setTitleColor(.myDarkGreen , for: .normal)
            sender.tintColor = .myDarkGreen
            sender.backgroundColor = nil
        } else {
            profile.isSidekick = true
            let sidekick = Sidekick()
            sidekick.username = UserSession.shared.getUsername()
            sidekick.sidekickName = profile.username
            if (profile.profileImage != nil) {
                sidekick.sidekickImage = profile.profileImage!
            }
            addSidekick(sidekick)
            sender.setTitle("Remove Sidekick", for: .normal)
            sender.setTitleColor(.black, for: .normal)
            sender.tintColor = .black
            sender.backgroundColor = .myBeige
    
        }
    }

    // UISearchResultsUpdating protocol
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if (searchText.isEmpty) {
                fetchData()
            } else {
                fetchData(searchText)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sidekickProfileSegue") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SidekickProfileViewController
            if let cell = sender as? UITableViewCell, let indexPath = accountsTableView.indexPath(for: cell) {
                let profile = profiles[indexPath.row]
                targetController.profile = profile
            }
        }
    }

    // MARK: Private Methods
    
    // Fetch the table data from the server
    private func fetchData(_ searchText: String? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        var parameters: Parameters? = nil
        if let query = searchText {
            parameters = ["username": "^"+query]
        }

        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.ProfilesURL, parameters: parameters, ofType: Profile.self) { (profiles, error) in
            if let error = error {
                return print("Get profiles error:", error.localizedDescription)
            }
            // If a profile is also my sidekick, flag it
            let tempProfiles = profiles.map({ (profile) -> Profile in
                if (self.sidekickNames.contains(profile.username!)) {
                    profile.isSidekick = true
                }
                return profile
            })
            self.profiles = tempProfiles
            for profile in self.profiles {
                print(profile.username ?? "")
            }
            DispatchQueue.main.async {
                self.accountsTableView.reloadData()
            }
        }
    }

    // Fetch the table data from the server
    private func fetchSidekicks() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = ["username": UserSession.shared.getUsername()]
        
        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.SidekicksURL, parameters: parameters, ofType: Sidekick.self) { (sidekicks, error) in
            if let error = error {
                return print("Get sidekicks error:", error.localizedDescription)
            }
            self.sidekicks = sidekicks
            // Collect the sidekick names into a simple String array for easier processing later
            self.sidekickNames = self.sidekicks.map({ (sidekick) -> String in (sidekick.sidekickName!) })
            for sidekick in self.sidekickNames {
                print(sidekick)
            }
        }
    }
    
    private func addSidekick(_ sidekick: Sidekick) {
        print("Add sidekick:", sidekick.sidekickName!)
        // Get the adventure objects from the server
        APIClient.postObjectToServer(Constants.SidekicksURL, object: sidekick) { (newSidekick, error) in
            if let error = error {
                return print("post sidekick error:", error.localizedDescription)
            }
            // Append the sidekick to the local arrays. Could call fetchSidekicks() instead
            self.sidekicks.append(newSidekick!)
            self.sidekickNames.append((newSidekick?.sidekickName)!)
        }
    }
    
    private func removeSidekick(_ sidekick: Sidekick) {
        print("Remove sidekick:", sidekick.sidekickName!)
        let reqURL = Constants.SidekicksURL + "/" + (sidekick._id)!
        APIClient.deleteObjectFromServer(reqURL)
        self.sidekicks = self.sidekicks.filter({ $0._id != sidekick._id })
        self.sidekickNames = self.sidekickNames.filter({ $0 != sidekick.sidekickName })
    }

}
