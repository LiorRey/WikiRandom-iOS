//
//  LangViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 10/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Firebase

// this is first screen which the user sees, as soon as logged succsessfully.
// if the user already logged once and didn't logout,the next time he will enter the game
// he will see this screen as the first screen after the LaunchScreen.
class LangViewController: UIViewController
{
    var langAbb : Language = Language.ENGLISH

    // we are using the Languages button's tags,in order to determine which language has been chosen
    @IBAction func languageSelect(_ sender: UIButton)
    {
        switch sender.tag
        {
            case 1: langAbb = Language.HEBREW
            case 2: langAbb = Language.ENGLISH
            case 3: langAbb = Language.RUSSIAN
            default: langAbb = Language.ENGLISH
        }
        
        performSegue(withIdentifier: "goToGame", sender: sender)
    }
        
    @IBAction func goToLeaderboard(_ sender: UIButton)
    {
        performSegue(withIdentifier: "goToLeaders", sender: sender)
    }
    
    @IBAction func goToAbout(_ sender: BorderedButton)
    {
        performSegue(withIdentifier: "goToAbout", sender: sender)
    }
    
    // the method that is connected to the "Logout" button, and does a logout process with firebase
    // *TLDR* - logouts the user from the game
    @IBAction func logoutAction(_ sender: BorderedButton)
    {
        let firebaseAuth = FIRAuth.auth()!
        do
        {
            try! firebaseAuth.signOut()
            FlowController.shared.determineRoot()
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    enum SegueIdentifier: String
    {
        case SegueToGameViewIdentifier = "goToGame"
        case SegueToLeadersViewIdentifier = "goToLeaders"
        case SegueToAboutViewIdentifier = "goToAbout"
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = SegueIdentifier(rawValue: segue.identifier!)
        {
             switch segueIdentifier
             {
                case .SegueToGameViewIdentifier :
                    let gameVc = segue.destination as! GameViewController
                    gameVc.langAbb = langAbb
                
                case .SegueToLeadersViewIdentifier :
                    _ = segue.destination as! LeaderboardViewController
                
                case .SegueToAboutViewIdentifier :
                    _ = segue.destination as! AboutViewController
                
                default:
                    return
            }
        }
    }
}
