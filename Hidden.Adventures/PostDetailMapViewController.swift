//
//  PostDetailMapViewController.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 8/8/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import MapKit

class PostDetailMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var adventure: Adventure?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting up annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake((adventure?.location?.coordinates![1])!,(adventure?.location?.coordinates![0])!)
        annotation.title = adventure?.name
        annotation.subtitle = adventure?.desc
        map.addAnnotation(annotation)
        
        // Setting location of spawn
        let span = MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: annotation.coordinate , span: span)
        map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
