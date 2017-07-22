//
//  AboutViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 27/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

// A screen expalaining WikiRandom and displaying some credits
class AboutViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // close the About screen and return to Language Selection Screen
    @IBAction func goToLang(_ sender: UIBarButtonItem)
    {
        navigationController?.popViewController(animated: true)
    }
}
