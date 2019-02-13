//
//  WaterViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/6/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class WaterViewController: UIViewController {

    
    var selectedCategory : Category?
    
    
    @IBAction func beach_CoveButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Beach_Cove"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func creek_RiverButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Creek_Rivers"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func bridgeButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Bridge"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func fishingButton(_ sender: UIButton) {
        selectedCategory?.value = "category.Fishing"
        self.performSegue(withIdentifier: "unwindToThirdViewController", sender: self)
    }
    
    @IBAction func swimmingHoleButton(_ sender: UIButton) {
        selectedCategory?.value = "category.SwimmingHole"
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
