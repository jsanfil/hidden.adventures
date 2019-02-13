//
//  ThirdVIewControllerViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 2/17/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import Alamofire

class ThirdVIewControllerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PassLocationDelegate, UITextViewDelegate {
   
    @IBOutlet weak var privateOutlet: UIButton!
    @IBOutlet weak var SidekicksOutlet: UIButton!
    @IBOutlet weak var publicOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIButton!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var currentLocationOutlet: UIButton!
    @IBOutlet weak var dropPinOutlet: UIButton!
    @IBOutlet weak var searchAddressOutlet: UIButton!
    @IBOutlet weak var categoryImage: UIImageView!
    var placeholderLabel : UILabel!

    // Post Data
    var newAdventure = Adventure()
    
    var imagePicked: UIImage?
    var imagePicker = UIImagePickerController()
    var imageName = ""

    var sidekickNames: [String]?
    var selectedCategory = Category()
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    var chosenCoordinate = CLLocationCoordinate2D()
    var currentLocationButtonState = false
    var dropPinButtonState = false
    var searchAddressButtonState = false
    var privateButtonState = false
    var sidekicksButtonState = false
    var publicButtonState = false
    var shouldResetMap: Bool = true
    
    // Present the camera or the photo library picker
    @IBAction func imageAction(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create the actions
        let firstAction: UIAlertAction = UIAlertAction(title: "Take Picture or Video", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // Delegate function: handles a selected image from camera or photo library
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        imagePicked = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        imageName = Utils.createNewImageName()
        dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image Picker cancelled")
        dismiss(animated: true, completion: nil)
    }

    func checkPhotoLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            case .authorized: print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            case .restricted: print("User do not have access to photo album.")
            case .denied: print("User has denied the permission.")
            }
        }
    
    @IBAction func privateButton(_ sender: UIButton) {
        // Turn off the other buttons
        SidekicksOutlet.tintColor = .lightGray
        sidekicksButtonState = false
        publicOutlet.tintColor = .lightGray
        publicButtonState = false
        
        // Turn on the selected button
        privateOutlet.tintColor = .myBrown
        privateButtonState = true
    }
    
    @IBAction func friendsButton(_ sender: UIButton) {
        // Turn off the other buttons
        privateOutlet.tintColor = .lightGray
        privateButtonState = false
        publicOutlet.tintColor = .lightGray
        publicButtonState = false
        
        // Turn on the selected button
        SidekicksOutlet.tintColor = .myBrown
        sidekicksButtonState = true
    }

    @IBAction func publicButton(_ sender: UIButton) {
        // Turn off the other buttons
        SidekicksOutlet.tintColor = .lightGray
        sidekicksButtonState = false
        privateOutlet.tintColor = .lightGray
        privateButtonState = false
        
        // Turn on the selected button
        publicOutlet.tintColor = .myBrown
        publicButtonState = true

    }
    
    private func clickCurrentLocationButton() {
        // Turn off the other buttons
        dropPinOutlet.tintColor = .lightGray
        dropPinButtonState = false
        searchAddressOutlet.tintColor = .lightGray
        searchAddressButtonState = false
        
        // Turn on the selected button
        currentLocationOutlet.tintColor = .myBrown
        currentLocationButtonState = true
    }
    
    private func clickDropPinButton() {
        // Turn off the other buttons
        currentLocationOutlet.tintColor = .lightGray
        currentLocationButtonState = false
        searchAddressOutlet.tintColor = .lightGray
        searchAddressButtonState = false
        
        // Turn on the selected button
        dropPinOutlet.tintColor = .myBrown
        dropPinButtonState = true
    }

    private func clickSearchAddressButton() {
        // Turn off the other buttons
        currentLocationOutlet.tintColor = .lightGray
        currentLocationButtonState = false
        dropPinOutlet.tintColor = .lightGray
        dropPinButtonState = false
        
        // Turn on the selected button
        searchAddressOutlet.tintColor = .myBlue
        searchAddressButtonState = true
    }

    // User taps the current location button
    @IBAction func currentLocationButton(_ sender: UIButton) {
        if currentLocation != nil {
            clickCurrentLocationButton()
            chosenCoordinate.latitude = (currentLocation?.coordinate.latitude)!
            chosenCoordinate.longitude = (currentLocation?.coordinate.longitude)!
        }
    }
    
    // PassLocationDelegate: This is called when the DropPin or Search address returns
    func passLocationBack(_ location: CLLocationCoordinate2D?, from: String) {
        // If location is not set, user cancelled from view so just return
        if location == nil {
            return
        }
        // On success, set the button state
        if (from == "DropPin") {
            clickDropPinButton()
        } else if (from == "SearchAddress") {
            clickSearchAddressButton()
        }
        // set the returned location
        chosenCoordinate = location!
    }
    
    // Post the adventure
    @IBAction func createPostButton(_ sender: UIButton) {
        if (!validatePostData()) {
            return
        }
        updateModelData()
        APIClient.uploadImage(imageName, image: imagePicked!)
        APIClient.postObjectToServer(Constants.AdventuresURL, object: newAdventure)
        let alert = UIAlertController(title: "Create Post", message: "New post succesfully created.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.clearViewData()
            }))
        self.present(alert, animated: true)
    }
    
    // Initialize the view the first time is is created
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategory.value = ""
 
        // Sets up location manager (constant gps)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        currentLocation = nil
        
        // Allow user to authorize photo use
        imagePicker.delegate = self
        checkPhotoLibraryPermission()
        
        // Set the placeholder text for description field
        descriptionOutlet.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter adventure description..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (descriptionOutlet.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionOutlet.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionOutlet.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.isHidden = !descriptionOutlet.text.isEmpty
        
        // Make all buttons start out as light gray
        
        currentLocationOutlet.tintColor = .lightGray
        dropPinOutlet.tintColor = .lightGray
        searchAddressOutlet.tintColor = .lightGray
        
        privateOutlet.tintColor = .lightGray
        SidekicksOutlet.tintColor = .lightGray
        publicOutlet.tintColor = .lightGray
    }
    
    // This gets called every time the view is at the top of the view stack
    override func viewWillAppear(_ animated: Bool) {
        print("ThirdViewController viewWillAppear()")
        updateViewData()
        fetchSidekicks()
        shouldResetMap = true
        locationManager.startUpdatingLocation()
    }
    
    // TextViewDelegate: hack for placeholder text in textView
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    // UIViewControllerDelegate: makes keyboard go away when tap outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    @IBAction func unwindFromOutdoorsCategoriesViewController(_ sender: UIStoryboardSegue) {
        print("unwind category", selectedCategory.value!)
        categoryImage.image = UIImage(named: selectedCategory.value!)
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "outdoorCategorySegway" {
            let destination = segue.destination as! OutdoorsCategoriesViewController
            destination.selectedCategory = selectedCategory
        }
        if segue.identifier == "waterCategorySegway" {
            let destination = segue.destination as! WaterViewController
            destination.selectedCategory = selectedCategory
        }
        if segue.identifier == "establishmentCategorySegway" {
            let destination = segue.destination as! EstablishmentViewController
            destination.selectedCategory = selectedCategory
        }
        if segue.identifier == "dropPinSegue" {
            let destination = segue.destination as! DropPinMapViewController
            destination.delegate = self
        }
        if segue.identifier == "searchAddressSegue" {
            let destination = segue.destination.children[0] as! SearchAddressViewController
            destination.delegate = self
            destination.currentLocation = self.currentLocation
        }
    }
   
    // MARK: - Private functions

    // Update the view after selecting an image
    private func updateViewData() {
        if let myImage = imagePicked {
            imageOutlet.setImage(myImage, for: .normal)
        } else {
            imageOutlet.setImage(UIImage(named: "addPhoto"), for: .normal)
        }
    }
    
    // Clear the view after a post
    private func clearViewData() {
        selectedCategory.value = ""
        currentLocationButtonState = false
        dropPinButtonState = false
        searchAddressButtonState = false
        privateButtonState = false
        sidekicksButtonState = false
        publicButtonState = false
        currentLocationOutlet.tintColor = .lightGray
        dropPinOutlet.tintColor = .lightGray
        searchAddressOutlet.tintColor = .lightGray
        privateOutlet.tintColor = .lightGray
        SidekicksOutlet.tintColor = .lightGray
        publicOutlet.tintColor = .lightGray
        titleOutlet.text?.removeAll()
        descriptionOutlet.text.removeAll()
        placeholderLabel.isHidden = false
        categoryImage.image = nil
        imagePicked = nil
        imageName = ""
        updateViewData()
    }
    
    private func validatePostData() -> Bool {
        var message = "The following fields are not set:\n"
        var isValid = true
        if (titleOutlet.text?.isEmpty)! {
            message.append("Title\n")
            isValid = false
        }
        if (descriptionOutlet.text.isEmpty) {
            message.append("Description\n")
            isValid = false
        }
        if (imagePicked == nil) {
            message.append("Image\n")
            isValid = false
        }
        if !(currentLocationButtonState || dropPinButtonState || searchAddressButtonState) {
            message.append("Location\n")
            isValid = false
        }
        if !(publicButtonState || privateButtonState || sidekicksButtonState) {
            message.append("Sharing Preferences\n")
            isValid = false
        }
        if (categoryImage.image == nil) {
            message.append("Category\n")
            isValid = false
        }
        if (!isValid) {
            let alert = UIAlertController(title: "Cannot Create Post", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        return isValid
    }
    // Populate the model object with all the properties collected in the view
    private func updateModelData() {
        newAdventure.name = titleOutlet.text
        newAdventure.author = UserSession.shared.getUsername()
        newAdventure.desc = descriptionOutlet.text
        newAdventure.rating = 0.0
        newAdventure.ratingCount = 0
        newAdventure.defaultImage = self.imageName
        newAdventure.category = selectedCategory.value?.deletingPrefix("category.")
        newAdventure.access = getSharingMode()
        if let pickedLocation = getLocation() {
            let location = Location()
            location.type = "Point"
            location.coordinates = pickedLocation
            newAdventure.location = location
            print("Chosen location", pickedLocation)
        }
        if let acl = self.sidekickNames {
            newAdventure.acl = acl
        }
    }

    // Determine which sharing mode button was selected
    private func getSharingMode() -> String {
        if publicButtonState == true {
            return "Public"
        } else if privateButtonState == true {
            return "Private"
        } else if sidekicksButtonState == true {
            return "Sidekicks"
        } else {
            return "None"
        }
    }
    
    // Get chosen location if one exists, and convert to [Double]
    private func getLocation() -> [Double]? {
        if (currentLocationButtonState || dropPinButtonState || searchAddressButtonState) {
            let location = [chosenCoordinate.longitude as Double, chosenCoordinate.latitude as Double]
            return location
        }
        return nil
    }
    
    // Fetch the sidekicks
    private func fetchSidekicks() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set query string to select profiles
        let parameters: Parameters? = ["username": UserSession.shared.getUsername()]
        
        // Get the adventure objects from the server
        APIClient.getObjectsFromServer(Constants.SidekicksURL, parameters: parameters, ofType: Sidekick.self) { (sidekicks, error) in
            if let error = error {
                return print("Get sidekicks error:", error.localizedDescription)
            }
            // Collect the sidekick names into a simple String array for easier processing later
            let sidekickNames = sidekicks.map({ (sidekick) -> String in (sidekick.sidekickName!) })
            self.sidekickNames = sidekickNames
        }
    }

    
}

extension ThirdVIewControllerViewController: CLLocationManagerDelegate {
    
    // Finds current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (shouldResetMap) {
            let latestLocation: CLLocation = locations[locations.count - 1]
            self.currentLocation = latestLocation
            print("ThirdView Controller locations = \(latestLocation.coordinate.latitude) \(latestLocation.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            shouldResetMap = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("I got a location error")
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
