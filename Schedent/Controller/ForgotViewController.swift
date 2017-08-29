//
//  ForgotViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 6/27/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Firebase

class ForgotViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        guard let emailAddress = emailTextField.text, emailAddress != "" else {
            let alertView = UIAlertController(title: "Input Error", message: "Please provide email to reset your password", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertView.addAction(alertAction)
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            
            let title = (error == nil) ? "password reset followUp" : "Password reset error"
            let message = (error == nil) ? "We have just sent an email. Please check your inbox to reset your password." : error?.localizedDescription
            let alertView = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                if error == nil {
                    
                    self.view.endEditing(true)
                    if let navController = self.navigationController {
                        
                        navController.popViewController(animated: true)
                    }
                }
            })
            alertView.addAction(alertAction)
            
            self.present(alertView, animated: true, completion: nil)
            
            
            
            
        }
        
    }


}
