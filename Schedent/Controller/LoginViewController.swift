//
//  LoginViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 6/26/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.'
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        }
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    @IBAction func loginAccount(_ sender: Any) {
        
        guard let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                let alertView = UIAlertController(title: "Login Error", message: "Please provide correct details to log in", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertView.addAction(alertAction)
                present(alertView, animated: true, completion: nil)
                
                return
        }
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            if let error = error {
                
                let alertView = UIAlertController(title: "Log in Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertView.addAction(alertAction)
                self.present(alertView, animated: true, completion: nil)
                
                return
                
            }
            // Check Email verification
            
            guard let currentUser = user, currentUser.isEmailVerified else {
                
                let alertView = UIAlertController(title: "Login Error", message: "You have not verified your email address yet. We sent you the confirmation.Please check your inbox and click on link. If you want us to resend the link again, Please Tap on resend", preferredStyle: UIAlertControllerStyle.alert)
                
                let resendAction = UIAlertAction(title: "Resend Email", style: UIAlertActionStyle.default, handler: { (action) in
                    user?.sendEmailVerification(completion: nil)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                
                alertView.addAction(resendAction)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
                
                return
            }
            self.view.endEditing(true)
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView"){
                
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
        
    }

  
    

}
