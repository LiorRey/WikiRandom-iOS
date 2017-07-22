//
//  LoginViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 08/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    //the method the responsible for logging the user to our app 
    @IBAction func loginAction(_ sender: BorderedButton)
    {
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter valid email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else
        {
            //if everything is ok , login the user to the app using firebase email method
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                
                if error == nil
                {
                    self.emailField.text = ""
                    FlowController.shared.determineRoot()
                }
                
                else
                {
                    // if there is an error , create a new alert with the error to the user
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        
        }
    }

    // Method that responsible for droping down from one TextField to Another using "Next"(keyboard)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
