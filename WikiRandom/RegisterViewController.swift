//
//  RegisterViewController.swift
//  WikiRandom
//
//  Created by Team Hurrange on 10/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatePasswordField: UITextField!
    
    var userNickname : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailField.delegate = self
        nicknameField.delegate = self
        passwordField.delegate = self
    }
    
    // A method that creats a new user in firebase and add a new database for him
    @IBAction func RegisterActionFirebase(_ sender: BorderedButton)
    {        
        // Checks that the inputs are valid!
        if self.emailField.text == "" || self.nicknameField.text == "" ||
            self.passwordField.text == ""
        {
            // If inputs are not valid return an Error
            let alertController = UIAlertController(title: "Oops!", message: "Please enter valid email, nickname and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Checks if the password contains at least 6 characters
        if ((passwordField.text?.characters.count)! < 6)
        {
            let alertController = UIAlertController(title: "Short password", message: "Your password must contain at least 6 characters", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Checks if the user typed his password correctly in both password fields
        if passwordField.text != repeatePasswordField.text
        {
            let alertController = UIAlertController(title: "Oops!", message: "Your passwords do not match!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // If everything is ok and there is no errors, Create the user
        FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user: FIRUser?, error) in
            
            if error == nil
            {
                // Saving the user unique UID
                guard let uid = user?.uid else
                {
                    return
                }
                
                // Creating a refes to the data base and to the specific childs within
                let dbRef = FIRDatabase.database().reference()
                let leaderboardReference = dbRef.child("leaderboard").child(uid)
                // Initializing the values we want to write to each of the newly created user data
                let values = ["nickname" : self.nicknameField.text!, "score" : 0 , "userID" : uid ] as [String : Any]
                // Creating the userData!
                leaderboardReference.updateChildValues(values, withCompletionBlock: { (error, dbRef) in
                    
                    // If there is an error fall here and return!
                    if error != nil
                    {
                        print(error)
                        return
                    }
                    
                    // If everything is ok return a print to log that indicates it!
                    print("Saved user successfully into Firebase!")
                    
                })
                
                // Empty every TextField after Registeration is complete
                self.emailField.text = ""
                self.passwordField.text = ""
                self.nicknameField.text = ""
                // Dismiss/Close the Registration Controller
                FlowController.shared.determineRoot()
            }
                
            else
            {
                // If there is an error creating the user , return a display of error
                let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
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
