//
//  ProfilePreferancesViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/30/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class ProfilePreferancesViewController: UIViewController {

    var showFavorites: Bool = false
    
  
    @IBOutlet weak var myPosts: UISwitch!
    @IBOutlet weak var myFavorites: UISwitch!
    
    
    @IBAction func myPostsSwitch(_ sender: UISwitch) {
        self.showFavorites = !sender.isOn
        flipSwitches(self.showFavorites)
    }
    
    
    @IBAction func myFavoritesSwitch(_ sender: UISwitch) {
        self.showFavorites = sender.isOn
        flipSwitches(self.showFavorites)
    }
    

    @IBAction func saveButton(_ sender: Any) {
        UserDefaults.standard.set(self.showFavorites, forKey: Constants.PREF_ProfileShowFavorites)
        self.performSegue(withIdentifier: "unwindToFifthViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showFavorites = UserDefaults.standard.bool(forKey: Constants.PREF_ProfileShowFavorites)
        flipSwitches(showFavorites)
    }

    private func flipSwitches(_ toggle: Bool) {
        if (toggle) {
            // show favorites
            myPosts.isOn = false
            myFavorites.isOn = true
        }
        else { // show posts
            myPosts.isOn = true
            myFavorites.isOn = false
        }
    }
 

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
