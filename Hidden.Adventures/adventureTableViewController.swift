//
//  AdventureTableViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 3/4/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class AdventureTableViewController: UITableViewController {
    
    // Properties:
  
    var adventures = [Adventure]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "adventureTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AdventureTableViewCell  else {
            fatalError("The dequeued cell is not an instance of adventureTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let adventure = adventures[indexPath.row]
        
        cell.AdventureLabel.text = adventure.name
        cell.AdventureImageView.image = adventure.photo

        
        return cell
    }
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
    // Private Methods:
    private func loadSampleAdventures() {
        let photo1 = UIImage (named: "exampleAdventure1")
        let photo2 = UIImage(named: "exampleAdventure2")
        let photo3 = UIImage(named: "exampleAdventure3")
        
        guard let exampleAdventure1 = Adventure(name: "River", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate exampleAdventure1")
        }
        
        guard let exampleAdventure2 = Adventure(name: "Rope Swing", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate exampleAdventure2")
        }
        
        guard let exampleAdventure3 = Adventure(name: "Cave", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate exampleAdventure3")
        }
        
        adventures += [exampleAdventure1, exampleAdventure2, exampleAdventure3]
    }
}
