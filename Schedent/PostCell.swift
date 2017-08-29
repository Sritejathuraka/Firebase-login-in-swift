//
//  PostCell.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 21/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    private var currentPost: Post?
    
    @IBOutlet weak var avatarImage: UIImageView!
  
    @IBOutlet weak var nameLabelText: UILabel!
    @IBOutlet weak var dateLabelText: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func configure(post: Post) {
        
        //set current post
        
        currentPost = post
        
        // set the cell style
        
        selectionStyle = .none
        
        //set name and vote count
        
        nameLabelText.text = post.user
        dateLabelText.text = "\(post.timestamp)"
        
        //Reset the image
        
        photoImageView.image = nil
        
        //Download the post image
        
        if let image = CacheManager.shared.getFromCache(Key: post.imageFileURL) as? UIImage {
            
            photoImageView.image = image
        }else {
            
            if let url = URL(string: post.imageFileURL) {
                
                let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let imageData = data else {
                        
                        return
                    }
                    OperationQueue.main.addOperation {
                        guard let image = UIImage(data: imageData) else {
                            
                            return
                        }
                        if self.currentPost?.imageFileURL == post.imageFileURL {
                            self.photoImageView.image = image
                        }
                        
                        // Add the download image to cache
                        
                        CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    }
                })
                
                downloadTask.resume()
            }
        }
    }
}
