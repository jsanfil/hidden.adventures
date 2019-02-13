//
//  EstablishmentViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/6/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class EstablishmentViewController: UIViewController {

    var selectedCategory : Category?

    @IBAction func barButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Bar"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func cafeButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Cafe"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func liveMusicButton(_ sender: UIButton) {
        selectedCategory?.value = "category.LiveMusic"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func restaurantButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Restaurant"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
