//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Russelle Pineda on 2/24/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    //container for tweets
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    //add a refresh control
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        //when screen is loaded for the first time, run everything accordingly in this func!
        loadTweets()
        
        //target - where you want it to happen.
        //selector - what do you want us to do?
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
        
    }
    
    @objc func loadTweets(){
        
        numberOfTweet = 20
            
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet] //can have more params here. just add ","

        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
                
            //empties entire array!
            self.tweetArray.removeAll()
                
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() //don't forget to reload
            self.myRefreshControl.endRefreshing() //to stop infinite spinning "load wheel"
            
        }, failure: { (Error) in
            print("Tweets not retrieved!")
        })
    }
    
    
    func loadMoreTweets(){
        
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        //increment 20 more tweets on top of initial tweets
        numberOfTweet = numberOfTweet + 20
        
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //empties entire array!
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() //don't forget to reload
            self.myRefreshControl.endRefreshing() //to stop infinite spinning "load wheel"
            
        }, failure: { (Error) in
            print("Tweets not retrieved!")
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        
        TwitterAPICaller.client?.logout() //logout function
        
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String //key under user is "name"
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        //code to get image of users! LEARN THIS!
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setReTweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count //return number of tweets in array!
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
