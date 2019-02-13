//
//  SidekickViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/8/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Alamofire

class SidekickViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var sidekickList = [Sidekick]()
    

    @IBOutlet weak var sidekickTableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sidekickTableView.delegate = self
        sidekickTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSidekicks()
    }

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sidekickList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "sidekickCell"
        
        guard let cell =
            sidekickTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            SidekickTableViewCell else {
                fatalError("The dequeued cell is not an instance of AccountsTableViewCell")
        }
        
        let sidekick = sidekickList[indexPath.row]
        
        cell.usernameLabel.text = "@" + sidekick.sidekickName!
        if (sidekick.sidekickImage != nil) {
            Utils.setImageView(cell.profilePicture, imageName: sidekick.sidekickImage!)
        }
       //circle profile pic
        cell.profilePicture.layer.borderWidth = 1
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.black.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
        
        return cell
       
    }
            
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sidekickDetailSegue") {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SidekickProfileViewController
            if let cell = sender as? UITableViewCell, let indexPath = sidekickTableView.indexPath(for: cell) {
                let sidekick = sidekickList[indexPath.row]
                targetController.sidekickName = sidekick.sidekickName
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
            self.sidekickList = sidekicks

            for sidekick in self.sidekickList {
                print("Sidekick:", sidekick.sidekickName!)
            }
            DispatchQueue.main.async {
                self.sidekickTableView.reloadData()
            }

        }
    }

}

