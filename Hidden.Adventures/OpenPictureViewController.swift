//
//  OpenPictureViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 2/7/19.
//  Copyright © 2019 Jack Sanfilippo. All rights reserved.
//

import UIKit

class OpenPictureViewController: UIViewController {

    var adventure: Adventure?
    
    @IBOutlet weak var defaultPic: UIImageView!
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (adventure?.defaultImage != nil) {
            Utils.setImageView(defaultPic, imageName: (adventure?.defaultImage)!)
        }
        // Do any additional setup after loading the view.
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
