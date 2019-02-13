//
//  DesignableButton.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 4/22/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {

    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
    didSet{
    self.layer.borderWidth = borderWidth
        }
    }
    
        @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
        self.layer.borderColor = borderColor.cgColor
    }
}
        @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
        self.layer.cornerRadius = cornerRadius
            }
    }
            
            
            
        /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


 }
