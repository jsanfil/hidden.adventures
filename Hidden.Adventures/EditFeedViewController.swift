//
//  EditFeedViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 3/19/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import StepSlider

class EditFeedViewController: UIViewController {

    
    
    // Outlets
    
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var sidekicksOnly: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stepSlider.labels = ["1Mi", "5Mi", "10Mi", "25Mi", "50Mi"]
        stepSlider.adjustLabel = true
        stepSlider.index = UInt(UserDefaults.standard.integer(forKey: Constants.PREF_FeedDistanceIndex))
        sidekicksOnly.isOn = UserDefaults.standard.bool(forKey: Constants.PREF_FeedSidekicksOnly)
    }

   
    @IBAction func saveFiltersButton(_ sender: Any) {
        UserDefaults.standard.set(Int(stepSlider.index), forKey: Constants.PREF_FeedDistanceIndex)
        UserDefaults.standard.set(sidekicksOnly.isOn, forKey: Constants.PREF_FeedSidekicksOnly)

        self.performSegue(withIdentifier: "editFeedUnwindSegue", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
