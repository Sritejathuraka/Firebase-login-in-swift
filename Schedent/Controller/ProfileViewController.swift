//
//  ProfileViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/1/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
   
    @IBOutlet var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let currentUser = Auth.auth().currentUser {
            
            nameLabel.text = currentUser.displayName
        }
    }
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutAccount(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch  {
            let alertView = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertView.addAction(alertAction)
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView"){
            
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }


   

}
