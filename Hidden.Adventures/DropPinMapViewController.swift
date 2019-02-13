//
//  DropPinMapViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/27/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol PassLocationDelegate: class {
    func passLocationBack(_ location: CLLocationCoordinate2D?, from: String)
}

class DropPinMapViewController: UIViewController, CLLocationManagerDelegate {
    
    weak var delegate: PassLocationDelegate?
    var chosenCoordinate: CLLocationCoordinate2D?

    @IBAction func saveLocation(_ sender: Any) {
        guard let coordinate = chosenCoordinate else {
            let alert = UIAlertController(title: "Location is not set", message: "Please drop a pin on the map where your adventure occurred.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        delegate?.passLocationBack(coordinate, from: "DropPin")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelMapView(_ sender: Any) {
        delegate?.passLocationBack(nil, from: "DropPin")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var initialLocation : CLLocation!
    let newPin = MKPointAnnotation()
    var shouldResetMap: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        map.showsUserLocation = true
        
        // Set the gesture recognizer
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        uilgr.minimumPressDuration = 0.5
        map.addGestureRecognizer(uilgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shouldResetMap = true
        locationManager.startUpdatingLocation()
    }
    
    // Add a pin to the map where the user long taps
    @objc func addPin(_ gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        map.removeAnnotations(map.annotations)
        map.addAnnotation(annotation)
        chosenCoordinate = newCoordinates
     }
    
    // This routine gets called when the user changes location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        if initialLocation == nil {
            initialLocation = latestLocation
        }
        print("DropPin location = \(latestLocation.coordinate.latitude) \(latestLocation.coordinate.longitude)")

        // zoom the map to your current location
        if (shouldResetMap) {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let region = MKCoordinateRegion(center: latestLocation.coordinate , span: span)
            map.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            shouldResetMap = false
        }

    }
    
    // Gets called if there is an error getting the user's location
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("I got a location error")
    }

}

