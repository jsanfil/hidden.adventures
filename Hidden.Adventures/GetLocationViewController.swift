//
//  GetLocationViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 12/27/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import MapKit

class GetLocationViewController: UIViewController {

    var adventure: Adventure?
    
    @IBAction func cancelButton(_ sender: UIButton) {
   self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getDirections(_ sender: UIButton) {
       openMapForPlace(location: (adventure?.location)!, name: (adventure?.name)!)
    }
    
    private func openMapForPlace(location: Location, name: String) {
        
        let coordinate = CLLocationCoordinate2DMake(location.coordinates![1], location.coordinates![0])
        let region = MKCoordinateRegion.init(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2))
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailMapSegue" {
            let destination = segue.destination as! PostDetailMapViewController
            destination.adventure = adventure
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
}
