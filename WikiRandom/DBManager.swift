//
//  DBManager.swift
//  WikiRandom
//
//  Created by Team Hurrange on 10/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Firebase

class DBManager: NSObject
{
    //maybe we dont need this one :
    static var manager = DBManager()

    var ref : FIRDatabaseReference!
    var leaderboardRef : FIRDatabaseReference!
    var scoreRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    var uid : String!
   
    override init()
    {
        super.init()
        
        // get the CurrentUser Uid
        uid = FIRAuth.auth()?.currentUser?.uid
        // reference to the root database
        ref = FIRDatabase.database().reference()
        // reference to the leaderboard "child" inside the root database
        leaderboardRef = ref.child("leaderboard")
        // reference to the user database
        userRef = leaderboardRef.child(uid)
        // reference to the points property/value of the CurrentUser inside the database
        scoreRef = leaderboardRef.child(uid).child("score")
    }
    
    func updateUserName(_ name : String)
    {
        guard let user = FIRAuth.auth()?.currentUser else
        {
            return
        }
        
        let request = user.profileChangeRequest()
        request.displayName = name
        
        request.commitChanges { (err) in
        }
        
    }
    
    // A method that gets the personal score of the CurrentUser
    func observeScore(completion : @escaping (Int)->Void)
    {
        // querying using the key "score" as a query
        let q = userRef.child("score")
        q.observe(.value, with: { (snapshot) in
            if let userSnapshotScore = snapshot.value as? Int
            {
                // returns the user's score As Int , upon completion
                completion(userSnapshotScore)
            }
            
            else
            {
                // if there is no score found , return 0
                completion(0)
            }
        })
    }
    
    // A method that updates the CurrentUser's score inside the firebase using reference
    func incrementMyHighscore(_ currentScore : Int)
    {
        userRef.updateChildValues(["score": currentScore + 1])
    }
    
    // A method that gets the top 10 leading users by score and adds them to an array
    func readHighscore(completion : @escaping ([User])->Void)
    {
        // querying top 10 users with the highest scores , using the key "score" as a query
        let q = leaderboardRef.queryOrdered(byChild: "score").queryLimited(toLast: 10)
        q.observe(.value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String:[String:Any]] else
            {
                completion([])
                return
            }

            var arr : [User] = []
            for (key, val) in dict
            {
                arr.append(User(uid: key, dict: val))
            }
            
            completion(arr)
        })
    }
}
