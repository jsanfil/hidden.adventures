//
//  SecondViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 2/15/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire


class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, CategoryListDelegate {
    
    @IBAction func filterButton(_ sender: Any) {
    
    }

    var isFirstTime = true
    var currentLocation : CLLocation!
    var adventures = [Adventure]()
    let locationManager = CLLocationManager()
    var selectedCategories: [String]?

    //outlets
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.delegate = self
        
        // Sets up location manager (constant gps)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        currentLocation = nil
        isFirstTime = true
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    // Reset the map to your current location
    @IBAction func nearMeAction(_ sender: UIButton) {
        isFirstTime = true
        locationManager.startUpdatingLocation()
    }
    
    // Fetch the table data from the server
    private func fetchData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = [
            "longitude": currentLocation?.coordinate.longitude as Any,
            "latitude": currentLocation?.coordinate.latitude as Any,
            "distance": 804672 // 500 miles
        ]
        
        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.AdventuresGeoURL, parameters: parameters, ofType: Adventure.self) { (adventures, error) in
            if let error = error {
                return print("Get adventures error:", error.localizedDescription)
            }
            self.adventures = adventures
            for adventure in self.adventures {
                print(adventure.name ?? "")
            }
            
            self.addAnnotionsToMap(selectedCategories: nil)
        }
    }

    // Add the adventures to the map
    private func addAnnotionsToMap(selectedCategories: [String]?) {
        var adventures = self.adventures
        if ((selectedCategories != nil) && ((!(selectedCategories?.isEmpty)!))) {
            adventures = self.adventures.filter { (selectedCategories?.contains($0.category!))! }
        }
        
        for adventure in adventures {
            print("Selected Adventure:", adventure.name ?? "", "Category:", adventure.category)
        }

        self.map.removeAnnotations(self.map.annotations)
        adventures.forEach { adventure in
            let annotation = CustomPointAnnotation()
            annotation.title = adventure.name
            let coordinate = CLLocationCoordinate2DMake((adventure.location?.coordinates![1])!, (adventure.location?.coordinates![0])!)
            annotation.coordinate = coordinate
            annotation.subtitle = adventure.desc
            annotation.imageName = "category." + adventure.category!
            self.map.addAnnotation(annotation)
        }
        DispatchQueue.main.async {
            self.map.setRegion(self.map.region, animated: true)
        }
    }

    // Finds current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        if currentLocation == nil {
            currentLocation = latestLocation
        }
        print("SecondViewController locations = \(latestLocation.coordinate.latitude) \(latestLocation.coordinate.longitude)")
        
        if (isFirstTime) {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let region = MKCoordinateRegion(center: latestLocation.coordinate , span: span)
            map.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            
            // Fetch the adventures from the server
            fetchData()
            
            map.showsUserLocation = true
            isFirstTime = false
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("I got a location error")
    }
    
    // MKMapViewDelegate function: Handles drawing annotationViews
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // if the annotion is a cluster annotion, set the desired color
        if let cluster = annotation as? MKClusterAnnotation {
            let markerAnnotationView = MKMarkerAnnotationView()
            markerAnnotationView.glyphText = String(cluster.memberAnnotations.count)
            markerAnnotationView.glyphTintColor = .myCreme
            markerAnnotationView.markerTintColor = UIColor.myBrown
            markerAnnotationView.canShowCallout = false
            
            return markerAnnotationView
        }
        
        // For normal annotations, set the image and color
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? CustomPointAnnotation else {return nil}
        let identifier = ""
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = .myBrown
        annotationView.glyphImage = UIImage(named: annotation.imageName)
        annotationView.glyphTintColor = .myCreme
        annotationView.clusteringIdentifier = identifier
        annotationView.canShowCallout = true
 //       annotationView.calloutOffset = CGPoint(x: -5, y: 5)
 //       annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        return annotationView
    }
    
    // MKMapViewDelegate function: called when viewable area is about to change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool){
        
        // Don't process any changes until the locationManager has set the initial position
        if (isFirstTime) {
            return
        }
        
        // Get the current map center
        let center = mapView.centerCoordinate as CLLocationCoordinate2D
        let getLat: CLLocationDegrees = center.latitude
        let getLon: CLLocationDegrees = center.longitude
        let movedMapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        let distanceInMeters = self.currentLocation.distance(from: movedMapCenter)
        
        // If the center of the map has moved more than 500 miles, reload annotations
        if (distanceInMeters > 804672) { // 500 miles
            self.currentLocation = movedMapCenter
            fetchData()
        }
    }
    
    // Override the didSelect and didDeselect methods to temorarily insert a
    // gesture recognizer. This allows us to segue to the adventure detail page
    // when selected on the 2nd tap.
    func mapView(_ mapView: MKMapView, didSelect view:MKAnnotationView) {
        if (view.annotation as? MKPointAnnotation) != nil {
            let tapGesture = UITapGestureRecognizer(target:self, action:#selector(calloutTapped(sender:)))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if (view.annotation as? MKPointAnnotation) != nil {
            view.removeGestureRecognizer(view.gestureRecognizers!.first!)
        }
    }
    
    // Segue to the adventure detail page if annotation tapped while selected
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        let view = sender.view as! MKAnnotationView
        if let annotation = view.annotation as? MKPointAnnotation {
            performSegue(withIdentifier: "fullPostSegue", sender: annotation)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullPostSegue" {
            let destination = segue.destination as! FullPostViewController
            if let annotation = sender as? MKPointAnnotation {
                let tempAdventures = adventures.filter {$0.name == annotation.title}
                if (!tempAdventures.isEmpty) {
                    destination.adventure = tempAdventures[0]
                } else {
                    print("Error: Segue. adventure details not found.", annotation.title)
                }
            }
        }
        if segue.identifier == "editMapSettings" {
            if let destVC = segue.destination as? EditMapSettingsViewController {
                destVC.delegate = self
            }
        }
    }
    
    //MARK: - CategoryListDelegate
    func sendSelectedCategories(selectedCategories : [String]) {
        self.selectedCategories = selectedCategories
        print("Selected Categories:", selectedCategories)
        self.addAnnotionsToMap(selectedCategories: selectedCategories)
    }
    
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

// Extend the annotation view so that when it is selected, the tap area gets expanded
extension MKAnnotationView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var frame: CGRect
        if (self.isSelected) {
            frame = self.bounds.insetBy(dx: -50, dy: -50);
        } else {
            frame = self.bounds
        }
        return frame.contains(point) ? self : nil;
    }
}

