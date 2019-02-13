//
//  InviteContactsViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/6/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class InviteContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    
    var contactList = [InvitedContact] ()
    var alert: UIAlertController?
    
  
    @IBOutlet weak var contactTableView: UITableView!

    // Handle the Send Invite button
    @IBAction func sendInvite(_ sender: UIBarButtonItem) {
        // Collect the phone numbers for all selected contacts
        var phoneNumbers = [String]()
        for invitedContact in contactList {
            if (invitedContact.isSelected) {
                if let phone = invitedContact.contact.phoneNumbers.first?.value.stringValue {
                    phoneNumbers.append(phone)
                }
            }
        }
        
        // Call the message app
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            let appStoreURL = "itms://itunes.apple.com/us/app/instagram/id389801252?mt=8"
            controller.body = "@" + UserSession.shared.getUsername() + " has invited you to Hidden Adventures. Please install the application. " + appStoreURL
            controller.recipients = phoneNumbers
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // Called when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()

        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        //Load the contacts
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            self.presentSettingsActionSheet()
            return
        }
        
        // open it        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            
            // get the contacts
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    let fullName = contact.givenName + " " + contact.familyName
                    self.contactList.append(InvitedContact(contact: contact, fullName: fullName, isSelected: false))
                    print(fullName)
                }
                self.contactList.sort { $0.fullName < $1.fullName}
                DispatchQueue.main.async {
                    self.contactTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to invite new sidekicks", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.topMostController().present(alert, animated: true)
    }
    
    // This is needed because the UIAlertController can't find the parent view controller in viewDidLoad()
    func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell {

            // If the button is ON toggle it OFF and set color to gray
            if contactList[indexPath.row].isSelected {
               cell.inviteButton.tintColor = .lightGray
                contactList[indexPath.row].isSelected = !contactList[indexPath.row].isSelected
                print("gray state:", contactList[indexPath.row].isSelected, "row:", indexPath.row)
                cell.contactName.textColor = .lightGray
            
            } else {
                // If the button is OFF toggle it ON and set color to green
                cell.inviteButton.tintColor = .myBlue
                contactList[indexPath.row].isSelected = !contactList[indexPath.row].isSelected
                print("blue state:", contactList[indexPath.row].isSelected, "row:", indexPath.row)
                 cell.contactName.textColor = .myBrown
            }

          
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "contactCell"
        guard let cell =
            contactTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            ContactTableViewCell else {
                fatalError("The dequeued cell is not an instance of AccountsTableViewCell")
       
        }
        
        let theContact = contactList[indexPath.row]
        cell.contactName.text = theContact.fullName
        
        // If contact is selected, toggle the button color to ON
        if contactList[indexPath.row].isSelected {
            cell.inviteButton.tintColor = .myBlue
            cell.contactName.textColor = .myBrown
            
           
        } else {
            cell.inviteButton.tintColor = .lightGray
            cell.contactName.textColor = .lightGray
        }
        
        return cell
    }
    
}
