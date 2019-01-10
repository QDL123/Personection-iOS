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
    
    //class level variables
    let sender: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
