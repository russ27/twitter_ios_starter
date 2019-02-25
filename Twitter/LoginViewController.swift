//
//  LoginViewController.swift
//  Twitter
//
//  Created by Russelle Pineda on 2/24/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            
            self.performSegue(withIdentifier: "logInToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        //print("Hello World!")
        
        //needs to be in between ""
        let loginUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //perform segue(we named segue/arrow "loginToHome")
            self.performSegue(withIdentifier: "logInToHome", sender: self)
            
        }, failure: { (Error) in
            print("Log in Unsuccessful")
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
