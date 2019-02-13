//
//  ReportButtonViewController.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 1/2/19.
//  Copyright © 2019 Jack Sanfilippo. All rights reserved.
//

import UIKit

class ReportButtonViewController: UIViewController, UITextViewDelegate {
    
    var adventure: Adventure?
    var message = Message()
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        message.username = UserSession.shared.getUsername()
        message.msgType = "ReportPost"
        message.body =  """
                        Report Post
                        Username: \(message.username!)
                        Adventure ID: \(adventure!._id!)
                        Adventure Name: \(adventure!.name!)
                        Adventure Author: \(adventure!.author!)
                        Description: \(descriptionOutlet.text!)
                        """
        APIClient.postObjectToServer(Constants.MessagesURL, object: message)
        let alert = UIAlertController(title: "Report Submitted", message: "Thank you for your feedback. We will investigate the issue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var descriptionOutlet: UITextView!

    var placeholderLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        descriptionOutlet.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Why are you reporting this post?"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (descriptionOutlet.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionOutlet.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionOutlet.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.isHidden = !descriptionOutlet.text.isEmpty
    }
  
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
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
