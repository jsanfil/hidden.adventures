//
//  EditMapSettingsViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 3/22/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

protocol CategoryListDelegate {
    func sendSelectedCategories(selectedCategories : [String])
}

class EditMapSettingsViewController: UIViewController {

    @IBOutlet var buttonOutlets:[UIButton]!
    
    var delegate: CategoryListDelegate!

    // Dictionary that holds the status of each category button (On or Off)
    var categoriesStatus = [String: Bool]()
    
    @IBAction func selectAllButton(_ sender: Any) {
        turnOnAllCategories()
    }
    
    @IBAction func clearAllButton(_ sender: Any) {
        turnOffAllCategories()
    }
    
    // Outdoor filter actions
    @IBAction func abandonedCategoryButton(_ sender: Any){
         toggleButton(sender)
    }
 
    @IBAction func caveCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func desertCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func forestCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func ropeswingCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func trailCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func viewpointCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func roadCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    // Water filter actions
    @IBAction func beach_coveCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func bridgeCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func creek_riverCategoryButton(_ sender: Any){
        toggleButton(sender)
    }
    
    @IBAction func fishingholeCategoryButton(_ sender: Any){
        toggleButton(sender)
    }
    
    @IBAction func swimmingholeCategoryButton(_ sender: Any){
        toggleButton(sender)
    }
    
    // Establishments filter actions
    @IBAction func barCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func cafeCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    
    @IBAction func livemusicCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    @IBAction func restaurantCategoryButton(_ sender: Any) {
        toggleButton(sender)
    }
    
    // Save filters button
    @IBAction func saveFiltersButton(_ sender: Any) {
        let filteredCategories = categoriesStatus.filter {$0.value == true}
        let categories = Array(filteredCategories.keys)
        self.dismiss(animated: true) {
            self.delegate.sendSelectedCategories(selectedCategories: categories)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonOutlets {
            categoriesStatus[button.restorationIdentifier!] = false
            button.tintColor = .myLightGreen
        }
    }

    func toggleButton (_ sender: Any){
        if let button = sender as? UIButton {
            let key = button.restorationIdentifier
            // If the button is ON toggle it OFF and set color to gray
            if categoriesStatus[key!]! {
                button.tintColor = .myLightGreen
                categoriesStatus[key!]! = !categoriesStatus[key!]!
            } else {
                // If the button is OFF toggle it ON and set color to green
                button.tintColor = .myBrown
                categoriesStatus[key!]! = !categoriesStatus[key!]!
            }
        }
    }
    
    // Turn ON all of the categories
    func turnOnAllCategories() {
        for category in categoriesStatus.keys {
            categoriesStatus[category] = true
        }
        for button in buttonOutlets {
            button.tintColor = .myBrown
        }
    }

    
    // Turn OFF all of the categories
    func turnOffAllCategories() {
        for category in categoriesStatus.keys {
            categoriesStatus[category] = false
        }
        for button in buttonOutlets {
            button.tintColor = .myLightGreen
        }
    }

}
