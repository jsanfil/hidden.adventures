//
// Copyright 2014-2018 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider

struct Constants {
    
    // URL's
    static let ServerURL = ENV.ServerURL
    static let AdventuresURL = ServerURL + "adventures"
    static let AdventuresGeoURL = ServerURL + "adventuresgeo"
    static let AdventuresGeoSidekicksOnlyURL = ServerURL + "adventuresgeosidekicksonly"
    static let AdventuresSidekicksURL = ServerURL + "adventuressidekicks"
    static let AdventuresFavoritesURL = ServerURL + "adventuresfavorites"
    static let ImagesURL = ServerURL + "images"
    static let ProfilesURL = ServerURL + "profiles"
    static let SidekicksURL = ServerURL + "sidekicks"
    static let FavoritesURL = ServerURL + "favorites"
    static let MessagesURL = ServerURL + "messages"

    // User preference keys
    static let PREF_AlreadyLaunched = "alreadylaunched"
    static let PREF_ProfileShowFavorites = "profileShowFavorites"
    static let PREF_FeedDistanceIndex = "feedDistanceIndex"
    static let PREF_FeedSidekicksOnly = "feedSidekicksOnly"

}

// Custom Colors
extension UIColor {
    static let myDarkGreen = UIColor(red: 137.0/255.0, green: 149.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    static let myBlue = UIColor(red: 63.0/255.0, green: 90.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    static let myBrown = UIColor(red: 76.0/255.0, green: 59.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    static let myCreme = UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 212.0/255.0, alpha: 1.0)
    static let myLightGreen = UIColor(red: 206.0/255.0, green: 213.0/255.0, blue: 163.0/255.0, alpha: 1.0)
    static let myBeige = UIColor(red: 195.0/255.0, green: 183.0/255.0, blue: 157.0/255.0, alpha: 1.0)
}

extension Notification.Name {
    public static let DidRegisterNewUser = Notification.Name(rawValue: "DidRegisterNewUser")
    public static let DidLogout = Notification.Name(rawValue: "DidLogout")
}
