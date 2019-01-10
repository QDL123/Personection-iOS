//
//  UserProfileViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/5/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    //Mark: Private variables
    private var user:User?
    
    //Mark: IBOutlet connections
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //Mark: IBAction
    @IBAction func friendButtonPushed(_ sender: Any) {
    }
    
    func setUpUI() {
        friendImage.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = profileImageView.frame.width
        profileImageView.image = UIImage(named: "profile")
        
        guard let user = self.user else {
            print("NO USER")
            return
        }
        let name = user.getFirstName() + " " + user.getLastName()
        print("NAME: " + name)
        self.navigationItem.title = name
    }
    
    func getUser() -> User {
        guard let user = self.user else {
            return User()
        }
        return user
    }
    
    func setUser(user:User) {
        self.user = user
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
