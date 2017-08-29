//
//  SignUpViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 6/26/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func registerAccount(_ sender: Any) {
        
        guard let name = nameTextField.text, name != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                
                let alertView = UIAlertController(title: "Register Error", message: "Please provide all the details to complete the sign up", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertView.addAction(alertAction)
                present(alertView, animated: true, completion: nil)
                
                return
        }
        
        //MARK: - Register the user account
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (user, error) in
            if let error = error {
                let alertView = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertView.addAction(alertAction)
                self.present(alertView, animated: true, completion: nil)
                
                return
            }
            
            //save the name of the user
            
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        
                        print("Failed to change display name: \(error.localizedDescription)")
                    }
                })
                
            }
            
            self.view.endEditing(true)
            // email verifivation
            
            user?.sendEmailVerification(completion: nil)
            let alertView = UIAlertController(title: "Email Verification", message: "We have just sent an confirmation email address to your email. Please check your inbox and click on verification link to complete the signup process", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertView.addAction(alertAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
  
    
    
}
