//
//  LeaderboardViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 26/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var leadersTableView: UITableView!

    //initializing the array of the top 10 scoreres , as an empty array at first
    var leadersArray : [User] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Get the top 10 scores from the database into an array
        DBManager.manager.readHighscore { (arr) in
            
            self.leadersArray = arr
            // Sort the scores by the scores from highest to lowest
            self.leadersArray.sort()
                {
                    $0.score > $1.score
            }
            self.leadersTableView.reloadData()
        }
    }
    
    deinit
    {
        DBManager.manager.leaderboardRef.removeAllObservers()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.leadersArray.count
    }
    
    // The method that has the logic which config each cell in the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaderCell
        
        // checking which indexPath we are at, and if we are the first,second or third.note it
        if indexPath.row == 0
        {
            cell.configure(with: leadersArray[indexPath.row], index: .FIRST)
        }
        else if indexPath.row == 1
        {
            cell.configure(with: leadersArray[indexPath.row], index: .SECOND)
        }
        else if indexPath.row == 2
        {
            cell.configure(with: leadersArray[indexPath.row], index: .THIRD)
        }
        else // if the indexPath is none of the above, which means its not one of the top 3
        {
            cell.configure(with: leadersArray[indexPath.row], index: .OTHER)
        }
        
        return cell
    }
    
    
    @IBAction func returnToLangAction(_ sender: UIBarButtonItem)
    {
        _ = navigationController?.popViewController(animated: true)
    }
}
