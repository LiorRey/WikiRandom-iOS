//
//  FlowController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 27/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Firebase

// this class is responsible for determining which screen will be shown first to user
class FlowController: NSObject
{
    weak var window : UIWindow?

    static let shared = FlowController()
    
    // the method that "works the magic" :)
    func determineRoot()
    {
        guard Thread.isMainThread else
        {
            DispatchQueue.main.async
                {
                    self.determineRoot()
            }
            return
        }
        
        // using the Firebase Auth , determine if the a user is logged in, and act acorrdingly
        let storyboardName = FIRAuth.auth()?.currentUser == nil ? "Login" : "Main"
        
        // init the InitialViewController(the first screen which the app will start)
        // using the storyBoardName.
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        window?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
