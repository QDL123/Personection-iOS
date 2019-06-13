//
//  OrientationViewController.swift
//  Personection
//
//  Created by Quintin Leary on 12/1/18.
//  Copyright © 2018 Quintin Leary. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class OrientationViewController: UIViewController {

    //Mark: IBOutlet Connections
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    //IDEA: Use enum to track what is being loaded.
    //class level variables
    let sender: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        themeColor = view.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        
        if(sender == 0) {
            //If user is not logged in send them to the log in screen
            if(Auth.auth().currentUser == nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                    // Your code with delay
                    self.performSegue(withIdentifier: "toLogIn", sender: self)
                }
            } else {
                print("SHOULD GO TO HOME")
                //Load initial data and then segue to home.
                //USE Promises here to download the data on all homescreens and then segue.
                print("CURRENT USER: " + Auth.auth().currentUser!.uid)
                CurrentUser.getCurrentUser().updateUser()
                print("Name: " + CurrentUser.getCurrentUser().getFirstName())
                print("Above is likely nil since the completion block hasn't finished.")
                performSegue(withIdentifier: "toHome", sender: self)
            }
        } else if (sender == 1) {
            
        }
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
