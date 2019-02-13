//
//  OutdoorsCategoriesViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/29/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class OutdoorsCategoriesViewController: UIViewController {
    
    var selectedCategory : Category?
    
    
    //buttons
    @IBAction func abandonedButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Abandoned"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func caveButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Cave"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func desertButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Desert"
      self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func forestButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Forest"
         self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
      
    }
    
    @IBAction func ropeSwingButton(_ sender: UIButton) {
        selectedCategory?.value = "category.RopeSwing"
         self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
       
   }
    
        @IBAction func trailButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Trail"
    self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    @IBAction func viewpointButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Viewpoint"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    
    @IBAction func roadButton(_ sender: UIButton) {
        selectedCategory?.value = "category.road"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }

}
