//
//  RatingViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 12/22/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {
   
    var adventure: Adventure?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var rating: CosmosView!
    
    @IBAction func submitButton(_ sender: UIButton) {
        if (rating.rating > 0){
            adventure?.rating = (adventure?.rating)! + rating.rating
            adventure?.ratingCount = (adventure?.ratingCount)! + 1
            let reqURL = Constants.AdventuresURL + "/" + (adventure?._id)!
            APIClient.updateObjectToServer(reqURL, object: adventure!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
