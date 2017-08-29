    //
    //  PostService.swift
    //  Schedent
    //
    //  Created by Sriteja Thuraka on 7/3/17.
    //  Copyright © 2017 Sriteja Thuraka. All rights reserved.
    //
    
    import Foundation
    import Firebase
    
    
    final class PostService {
        
        // MARK: - Properties
        
        static let shared: PostService = PostService()
        private init(){}
        
        // MARK: - Firebase Database reference
        
        
        let BASE_DB_REF: DatabaseReference = Database.database().reference()
        let POST_DB_REF: DatabaseReference = Database.database().reference().child("posts")
        
        // MARK: - Firebase Storage reference
        
        let PHOTO_STORAGE_REF: StorageReference = Storage.storage().reference().child("photos")
        
        // MARK: - Firebase upload and download methods
        
        func uploadData(image: UIImage, eventName: String, eventDate: String, location: String, description: String, completionHandler: @escaping () -> Void)  {
            
            // Generating Unique key for the post and prepare the post datebase reference
            
            let postDatabaseRef = POST_DB_REF.childByAutoId()
            
            // use the unique key as image name and prepare the storage reference
            
            let imageStorageRef = PHOTO_STORAGE_REF.child("\(postDatabaseRef.key).jpg")
            
            // resize the image
            
            let scaledImage = image.scale(newWidth: 640.0)
            
            guard let imageData = UIImageJPEGRepresentation(scaledImage, 0.9) else {
                return
            }
            
            // Create the file Metadata
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            // prepare the upload task
            
            let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
            
            //observe the upload status = success
            
            uploadTask.observe(.success) { (snapshot) in
                guard let displayname = Auth.auth().currentUser?.displayName else {
                    return
                }
                // Add a reference in database
                
                if let imageFileURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
                    let post : [String : Any] = [Post.PostInfoKey.imageFileURL : imageFileURL, Post.PostInfoKey.timestamp : timestamp, Post.PostInfoKey.user : displayname, Post.PostInfoKey.eventName : eventName, Post.PostInfoKey.eventDate : eventDate, Post.PostInfoKey.location : location, Post.PostInfoKey.description : description]
                    postDatabaseRef.setValue(post)
                }
                completionHandler()
            }
            
            //observe the upload status = progress
            
            uploadTask.observe(.progress) { (snapshot) in
                let percentageComplete =  ((Double((snapshot.progress?.completedUnitCount)!)) / Double((snapshot.progress?.totalUnitCount)!) * 100)
                
                print("Uploading Data......\(percentageComplete)% complete")
            }
            
            //observe the upload status = failure
            
            uploadTask.observe(.failure) { (snapshot) in
                
                if let error = snapshot.error {
                    print("Uploading error : \(error.localizedDescription)")
                }
            }
            
        }
        // MARK: - get recent posts
        
        
        func getRecentPosts(start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping([Post]) -> Void) {
            
            var postQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
            if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
                // if the timestamp is specified, we will get the posts with timestamp newer that the given value
                
                postQuery = postQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: Post.PostInfoKey.timestamp).queryLimited(toLast: limit)
                
            } else {
                
                // Otherwise we will get recent posts
                
                
                postQuery = postQuery.queryLimited(toLast: limit)
            }
            
            
            // Call Firebase API to retrieve the latest records
            
            postQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                
                var newPosts: [Post] = []
                
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let postInfo = item.value as? [String : Any] ?? [:]
                    
                    if let post = Post(postId: item.key, postInfo: postInfo) {
                        
                        newPosts.append(post)
                    }
                    
                }
                if newPosts.count > 0 {
                    
                    // Order in descending Order
                    
                    newPosts.sort(by: {$0.timestamp > $1.timestamp})
                }
                completionHandler(newPosts)
                
            })
        }
        
        // Get old posts
        
        func getOldPosts(start timestamp: Int, limit: UInt, completionHandler: @escaping ([Post]) -> Void) {
            
            let postOrderedQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
            let postLimitedQuery = postOrderedQuery.queryEnding(atValue: timestamp - 1, childKey: Post.PostInfoKey.timestamp).queryLimited(toLast: limit)
            postLimitedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                var newPosts: [Post] = []
                
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    print("Post Key: \(item.key)")
                    let postInfo = item.value as? [String : Any] ?? [:]
                    if let post = Post(postId: item.key, postInfo: postInfo) {
                        
                        newPosts.append(post)
                    }
                }
                // Ordered in descending order
                
                newPosts.sort(by: {$0.timestamp > $1.timestamp})
                completionHandler(newPosts)
                
            })
        }
        
        
    }
    
    
