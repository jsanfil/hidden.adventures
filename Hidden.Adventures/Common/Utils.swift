//
//  Utils.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-06-29.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Async

class Utils {
    
    // Create a unique name to store photo's in the cloud "<username>_<uuid>.jpg"
    class func createNewImageName() -> String {
        let imageName = UserSession.shared.getUsername() + "_" + UUID().uuidString.lowercased() + ".jpg"
        return imageName
    }
    
    // Use Kingfisher to provide cached images for UIImageViews
    class func setImageView(_ view: UIImageView, imageName: String) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: setImageView(): token is nil")
            return
        }
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            return r
        }
        let url = URL(string: Constants.ImagesURL + "/" + (imageName))!
        let resource = ImageResource(downloadURL: url, cacheKey: imageName)
        view.kf.setImage(with: resource, placeholder: nil, options: [.requestModifier(modifier)],
            completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image == nil || error != nil) {
                print("Error: setImageView:", imageUrl!, error!)
                Async.main(after: 3.0) {
                    setImageView(view, imageName: imageName)
                }
            }
        })
    }

    // Use Kingfisher to provide cached images for UIButtons
    class func setButtonImage(_ btn: UIButton, imageName: String) {
        guard let token = UserSession.shared.getToken() else {
            print("Error: setButtonImage(): token is nil")
            return
        }
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            return r
        }
        let url = URL(string: Constants.ImagesURL + "/" + (imageName))!
        let resource = ImageResource(downloadURL: url, cacheKey: imageName)
        btn.kf.setImage(with: resource, for: .normal, placeholder: nil, options: [.requestModifier(modifier)],
            completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image == nil || error != nil) {
                print("Error: setButtonImage:", imageUrl!, error!)
                Async.main(after: 3.0) {
                    setButtonImage(btn, imageName: imageName)
                }
            }
        })
    }

}
