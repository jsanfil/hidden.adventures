
//
//  EditProfilePageViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/22/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Photos

class EditProfilePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var addPhoto: DesignableButton!    
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var backgroundPhoto: DesignableButton!
    
    var myProfile: Profile?
    var imagePicker = UIImagePickerController()
    var profileImagePicked: UIImage?
    var profileImageName: String?
    var backgroundImagePicked: UIImage?
    var backgroundImageName: String?
    var isProfileImageSelected = false
   
    @IBAction func saveChangesButton(_ sender: UIBarButtonItem) {
        updateModelData()
        if (profileImagePicked != nil) {
            APIClient.uploadImage(profileImageName!, image: profileImagePicked!)
        }
        if (backgroundImagePicked != nil) {
            APIClient.uploadImage(backgroundImageName!, image: backgroundImagePicked!)
        }
        let reqURL = Constants.ProfilesURL + "/" + (myProfile?._id)!
        APIClient.updateObjectToServer(reqURL, object: myProfile!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO","MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.statePickerView.delegate = self
        self.statePickerView.dataSource = self
        
        // Allow user to authorize photo use
        imagePicker.delegate = self
        checkPhotoLibraryPermission()
        
        //circle around profile picture
        addPhoto.layer.borderWidth = 1
        addPhoto.layer.masksToBounds = false
        addPhoto.layer.borderColor = UIColor.black.cgColor
        addPhoto.layer.cornerRadius = addPhoto.frame.height/2
        addPhoto.clipsToBounds = true
        
        // Load the view with profile data
        updateViewData()
    }
    
    // This gets called every time the view is at the top of the view stack
    override func viewWillAppear(_ animated: Bool) {
        print("EditProfilePageViewController viewWillAppear()")
        if let profImage = profileImagePicked {
            addPhoto.setImage(profImage, for: .normal)
        }
        if let backImage = backgroundImagePicked {
            backgroundPhoto.setImage(backImage, for: .normal)
        }
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        stateLabel.text = states[row]
    }
    
    // Select the profile photo
    @IBAction func profilePicAction(_ sender: Any) {
        isProfileImageSelected = true
        popPhotoPicker()
    }
    
    // Select the background photo
    @IBAction func backgroundPicAction(_ sender: Any) {
        popPhotoPicker()
    }
    
    // This routine pops the photo picker action sheet
    func popPhotoPicker() {
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // Delegate function: handles a selected image from camera or photo library
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if isProfileImageSelected {
            profileImageName = Utils.createNewImageName()
            profileImagePicked = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        } else {
            backgroundImageName = Utils.createNewImageName()
            backgroundImagePicked = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        }
        isProfileImageSelected = false
        dismiss(animated: true, completion: nil)
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

    // UIViewControllerDelegate: makes keyboard go away when tap outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // MARK: - Private Functions
    
    // Update the view after selecting an image
    private func updateViewData() {
        email.text = myProfile?.email ?? ""
        fullName.text = myProfile?.fullName ?? ""
        city.text = myProfile?.city ?? ""
        stateLabel.text = myProfile?.state ?? ""
        if ((myProfile?.profileImage) != nil) {
            Utils.setButtonImage(addPhoto, imageName: (myProfile?.profileImage)!)
        }
        if ((myProfile?.backgroundImage) != nil) {
            Utils.setButtonImage(backgroundPhoto, imageName: (myProfile?.backgroundImage)!)
        }
    }
    
     // Update the model after editing view
    private func updateModelData() {
        myProfile?.email = email.text
        myProfile?.fullName = fullName.text
        myProfile?.city = city.text
        myProfile?.state = stateLabel.text
        if (profileImageName != nil) {
            myProfile?.profileImage = profileImageName
        }
        if (backgroundImageName != nil) {
            myProfile?.backgroundImage = backgroundImageName
        }
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
