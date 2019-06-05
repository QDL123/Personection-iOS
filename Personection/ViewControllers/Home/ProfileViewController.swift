//
//  ProfileViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/18/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileimageview: UIImageView!
    
    
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        let currentUser = CurrentUser.currentUser
        let name = currentUser.getFirstName() + " " + currentUser.getLastName()
        print("NAME: " + name)
        let realUser = CurrentUser.currentUser
        let realName = realUser.getFirstName() + " " + realUser.getLastName()
        print("REAL NAME: " + realName)
        self.navigationItem.title = realName
        
        
        profileimageview.layer.cornerRadius = 5
        profileimageview.contentMode = .scaleAspectFit
        
        
        let firstName = currentUser.getFirstName()
        
        if(firstName == "Brent") {
            profileimageview.image = UIImage(named: "BrentBurns.jpg")
            bioTextView.text = "Bio: NHL defenseman currently playing for the San Jose Sharks"
        } else if (firstName == "Evander") {
            profileimageview.image = UIImage(named: "EvanderKane.png")
            bioTextView.text = "Bio: NHL forward currently playing for the San Jose Sharks"
        } else {
            profileimageview.image = UIImage(named: "LoganCouture.jpg")
            bioTextView.text = "Bio: NHL forward currently playing for the San Jose Sharks"
        }

        
        profileimageview.layer.borderWidth = 1
        profileimageview.layer.masksToBounds = false
        profileimageview.layer.borderColor = UIColor.black.cgColor
        profileimageview.layer.cornerRadius = profileimageview.frame.height/2
        profileimageview.clipsToBounds = true
        
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
