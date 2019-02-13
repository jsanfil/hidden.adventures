//
//  Utils.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-06-02.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class UserSession {

    // MARK: - Properties

    // Singleton Instance variable
    static let shared = UserSession()
    
    var pool: AWSCognitoIdentityUserPool?
    var session: AWSCognitoIdentityUserSession?
    var newUserProfile: Profile?
    var currentUsername: String?
    
    init() {
        NotificationCenter.default.addObserver(forName: .DidRegisterNewUser, object: nil, queue: nil, using: handleDidRegisterNewUser(_:))
    }
    
    func initialize() {
        // Dummy routine to initialize the singleton at startup
    }

    // Get the JWT ID Token for the logged in user
    func getToken() -> String? {
        print("in getToken()")
        // Init the pool variable the first time this method is called
        if ((self.pool == nil)) {
            self.pool = AWSCognitoIdentityUserPool.init(forKey: ENV.AWSCognitoUserPoolsSignInProviderKey)
        }
        // Check if the user exists, if not force a login
        guard let user = pool?.currentUser() else {
            getSession()
            return nil
        }
        // check if the user is signed out, if so force a login
        if (!(user.isSignedIn)) || (self.session == nil) || (self.currentUsername != self.getUsername()) {
            getSession()
            return nil
        }
        // If we got here, we've got a current logged in user and session
        // If the token is going to expire within 5 minutes force a token refresh
        // print(self.session?.expirationTime)
        // print(Date(timeIntervalSinceNow: 5*60))
        if ((self.session?.expirationTime)! < Date(timeIntervalSinceNow: 5*60)) {
            getSession()
        }
        return self.session?.idToken?.tokenString
    }
    
    // Get the session for the logged in user. If not logged in, force the login screen to pop
    func getSession(){
        self.pool?.currentUser()?.getSession().continueOnSuccessWith { (getSessionTask) -> AnyObject? in
            // DispatchQueue.main.async(execute: {
                self.session = getSessionTask.result
            self.currentUsername = self.getUsername()
            print("in getSession(). Set a new token.")
            // })
            return nil
        }
    }
    
    // Get the username of the current logged in user
    func getUsername() -> String {
        // By the time this gets called, there should be a username. If not, we are screwed.
        return (self.pool?.currentUser()?.username)!
    }
    
    // handle DidRegisterNewUser notification - Step 1
    func handleDidRegisterNewUser(_ notification: Notification) {
        if let profile = notification.userInfo?["profile"] as? Profile {
            self.newUserProfile = profile
        }
    }
    
    /* Step 2 - This is insanely convoluted. Thank you Cognito. This func gets called after the login
     or logout screen completes. A new user may have registered. But we need to delay until we have a token
     before we can post a new Profile for that user. So we can't do the postProfile() immediately.
     If we received a DidUserRegisterNotification, the self.newUserProfile property will not be nil.
    */
    func checkRegisterNewUser() {
        if let profile = self.newUserProfile {
            print("registerNewUser()", profile.username)
            APIClient.postObjectToServer(Constants.ProfilesURL, object: profile)
            self.newUserProfile = nil
        }
    }
    
}
