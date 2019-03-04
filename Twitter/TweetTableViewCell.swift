//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Russelle Pineda on 2/24/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweetId:Int = -1
    var favorited:Bool = false
    var didReTweeted:Bool = false
   
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let tobeFavorited = !favorited
        if(tobeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
                
            })
        }
        else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
        
    }
    
    //character count
    //tweetLabel.delegate = self
    
    @IBAction func retweetActionButton(_ sender: Any) {
        let tobeReTweeted = !didReTweeted
        if(tobeReTweeted){
            TwitterAPICaller.client?.reTweet(tweetId: tweetId, success: {
                self.setReTweeted(true)
            }, failure: { (error) in
                print("Error in retweeting: \(error)")
            })
        }
        else {
            TwitterAPICaller.client?.unReTweet(tweetId: tweetId, success: {
                self.setReTweeted(false)
            }, failure: { (error) in
                print("Retweeting did not succeed: \(error)")
            })
        }
    }
        
    
    
    
    
    func setReTweeted(_ isReTweeted:Bool){
        didReTweeted = isReTweeted
        //if(isReTweeted){
          if(didReTweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if(favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
            
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
