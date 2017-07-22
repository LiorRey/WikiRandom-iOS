//
//  User.swift
//  WikiRandom
//
//  Created by Team Hurrange on 24/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

// this class represents a user details from our firebase database
class User: NSObject
{
    enum Keys : String
    {
        case USERID = "userID"
        case NICKNAME = "nickname"
        case SCORE = "score"
    }
    
    let uid : String
    let userID : String
    let nickname : String
    let score : Int
    
    init(uid : String, dict : [String:Any])
    {
        self.uid = uid
        self.userID = dict[Keys.USERID.rawValue] as! String
        self.nickname = dict[Keys.NICKNAME.rawValue] as! String
        self.score = dict[Keys.SCORE.rawValue] as! Int
        
        super.init()
    }
}
