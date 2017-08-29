//
//  Post.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/3/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import Foundation

struct Post {
  
    // MARK: - Properties
    
    var postId: String
    var imageFileURL: String
    var user: String
    var eventName: String
    var eventDate: String
    var location: String
    var description: String
    var timestamp: Int
    
    // MARK: - Firebase Keys
    
    enum PostInfoKey {
        static let imageFileURL = "imageFIleURL"
        static let user = "user"
        static let eventName = "eventName"
        static let eventDate = "eventDate"
        static let location = "location"
        static let description = "description"
        static let timestamp = "timestamp"
        
    }
    // MARK: - Initialization
    
    init(postId: String, imageFileURL: String, user: String, eventName: String, eventDate: String, location: String, description: String, timestamp: Int = Int(NSDate().timeIntervalSince1970 * 1000)) {
        self.postId = postId
        self.imageFileURL = imageFileURL
        self.user = user
        self.eventName = eventName
        self.location = location
        self.eventDate = eventDate
        self.description = description
        self.timestamp = timestamp
    }
    init?(postId: String, postInfo: [String : Any]) {
        
        guard let imageFileURL = postInfo[PostInfoKey.imageFileURL] as? String,
              let user = postInfo[PostInfoKey.user] as? String,
              let eventName = postInfo[PostInfoKey.eventName] as? String,
            let eventDate = postInfo[PostInfoKey.eventDate] as? String,
            let location = postInfo[PostInfoKey.location] as? String,
            let description = postInfo[PostInfoKey.description] as? String,
              let timestamp = postInfo[PostInfoKey.timestamp] as? Int else {
            
                 return nil
                
        }
        self = Post(postId: postId, imageFileURL: imageFileURL, user: user, eventName: eventName, eventDate: eventDate, location: location,description: description, timestamp: timestamp)
    }
    

}
