//
//  PostFeedTableViewController.swift
//  Schedent
//
//  Created by Sriteja Thuraka on 7/1/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import Firebase
import Fusuma


class PostFeedTableViewController: UITableViewController {
    
    var postfeed: [Post] = []
    fileprivate var isLoadingPost = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostService.shared.getRecentPosts(limit: 3) { (newPosts) in
            
            newPosts.forEach({ (post) in
                print("-----------------")
                print("POST ID: \(post.postId)")
                print("ImageURL: \(post.imageFileURL)")
                print("User: \(post.user)")
                print("EvenName: \(post.eventName)")
                print("EventDate: \(post.eventDate)")
                print("Description: \(post.description)")
                print("Location: \(post.location)")
                
            })
            
            
        }
        
        
        //Configure the Pull refresh
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.black
        refreshControl?.addTarget(self, action: #selector(loadingRecentPosts), for: UIControlEvents.valueChanged)
        
        // Loading Posts
        loadingRecentPosts()
        
    }
    
    @IBAction func unwindToHomeScree(segue:UIStoryboardSegue) {
        
        
    }

    
    // MARK: - Methods for Load post and display posts
    
    // Load post
    
    @objc fileprivate func loadingRecentPosts(){
        
        isLoadingPost = true
        PostService.shared.getRecentPosts(start: postfeed.first?.timestamp, limit: 10) { (newPosts) in
            if newPosts.count > 0 {
                
                // Add the array to the begining of posts array
                self.postfeed.insert(contentsOf: newPosts, at: 0)
            }
            self.isLoadingPost = false
            
            if let _ = self.refreshControl?.endRefreshing() {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                })
            } else{
                self.displayNewPosts(newPosts: newPosts)
            }
            
        }
    }
    
    
    private func displayNewPosts(newPosts posts: [Post]) {
        
        // Make sure we got some new posts to display
        
        guard posts.count > 0 else {
            
            return
        }
        // Display the posts by inserting them to tableview
        var inderPaths : [IndexPath] = []
        self.tableView.beginUpdates()
        for num in 0...(posts.count - 1) {
            
            let indexpath = IndexPath(row: num, section: 0)
            inderPaths.append(indexpath)
        }
        self.tableView.insertRows(at: inderPaths, with: .fade)
        self.tableView.endUpdates()
    }
}
// MARK: - Table view Methods


extension PostFeedTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postfeed.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        
        let currentPost = postfeed[indexPath.row]
        cell.configure(post: currentPost)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // we want to trigger the loading when user reaches the last two rows
        
        guard !isLoadingPost, postfeed.count - indexPath.row == 2 else {
            return
        }
        
        isLoadingPost = true
        guard let lastPostTimestamp = postfeed.last?.timestamp else {
            isLoadingPost = true
            return
            
        }
        PostService.shared.getOldPosts(start: lastPostTimestamp, limit: 3) { (newPosts) in
            // Add new posts to exixting array and table view
            
            var indexPaths: [IndexPath] = []
            self.tableView.beginUpdates()
            for newPost in newPosts {
                
                self.postfeed.append(newPost)
                let indexPath = IndexPath(row: self.postfeed.count - 1, section: 0)
                indexPaths.append(indexPath)
            }
            self.tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            self.isLoadingPost = false
        }
    }
}




