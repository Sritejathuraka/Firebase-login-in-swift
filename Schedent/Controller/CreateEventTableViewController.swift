//
//  CreateEventTableViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/13/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Fusuma
import Firebase

class CreateEventTableViewController: UITableViewController, FusumaDelegate {
   
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let fusumaViewController = FusumaViewController()
            fusumaViewController.hasVideo = false
            fusumaBackgroundColor = UIColor.black
            fusumaTintColor = UIColor(colorLiteralRed: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
            fusumaViewController.view.backgroundColor = UIColor.black
            fusumaViewController.delegate = self
            present(fusumaViewController, animated: true, completion: nil)
        }
    }
    // MARK: - Fusuma Delegate methods
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        photoImageView.image = image
        
        NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
   
    func fusumaCameraRollUnauthorized() {
        let alertController = UIAlertController(title: "Request Access", message: "We need to access your photo library for saving and retrieving your photos. Please choose settings to grant us the accessrignt", preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        
        presentedViewController?.present(alertController, animated: true, completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
        
      PostService.shared.uploadData(image: photoImageView.image!, eventName: eventNameText.text!, eventDate:dateText.text!, location: locationText.text!, description: descriptionText.text!) { 
        
            self.dismiss(animated: true, completion: nil)
           
        }
       
        
    }



}
