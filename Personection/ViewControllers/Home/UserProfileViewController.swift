//
//  UserProfileViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/5/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, RelationDelegate {
    
    //Mark: Private variables
    private var user:User?
    
    var segueName:String?
    
    //Mark: IBOutlet connections
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var relationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Did load view")
        if let name = segueName {
            if name == "friendRequestDetail" {
                print("Should change button appearance")
                relationButton.titleLabel?.text = "Accept Friend Request"
                relationButton.setTitle("Accept Friend Request", for: .normal)
                relationButton.titleLabel?.adjustsFontSizeToFitWidth = true
                user?.setRelation(relation: UserRelation.requestReceived)
            }
        }

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //Mark: IBAction
    @IBAction func friendButtonPushed(_ sender: Any) {
        
        if let user = user {
            let relation = user.getRelation()
            let firstName = user.getFirstName()
            let lastName = user.getLastName()
            
            if relation == UserRelation.none {
                let titleString = "Send Friend Request?"
                
                let messageString = "Would you like to send a friend request to " + firstName + " " + lastName + "?"
                
                let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
                    self.sendFriendRequest()
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alertController, animated: true, completion: nil)
            } else if relation == UserRelation.requestReceived {
                let titleString = "Accept Friend Request?"
                let messageString = "Would you like to accept " + firstName + " " + lastName + "'s friend request?"
                
                let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
                    self.acceptFriendRequest()
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            } else if relation == UserRelation.requestSent {
                
            } else if relation == UserRelation.friend {
                
            }
        }
        
    }
    
    func acceptFriendRequest() {
        guard let id = self.user?.getID() else {
            print("Error: Couldn't get user id")
            return
        }
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error: Couldn't get user current user id")
            return
        }
        
        let db = Firestore.firestore()
        
        //Remove user from current user's friend requests
        db.collection("users").document(currentUser).collection("friendRequests").document(id).delete()
        
        //Add user to current user's friends
        db.collection("users").document(currentUser).collection("friends").document(id).setData([
            "firstName":CurrentUser.getCurrentUser().getFirstName(),
            "lastName":CurrentUser.getCurrentUser().getLastName()
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        
        //Add current user to user's friends
        db.collection("users").document(id).collection("friends").document(currentUser).setData([
            "firstName":CurrentUser.getCurrentUser().getFirstName(),
            "lastName":CurrentUser.getCurrentUser().getLastName()
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        
    }
    
    func sendFriendRequest() {
        print("SHOULD SEND FRIEND REQUEST")
        guard let id = self.user?.getID() else {
            print("Error: Getting user id")
            return
        }
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("Error: getting current User")
            return
        }
        
        let db = Firestore.firestore()
        let timeStamp = Date().timeIntervalSince1970
        db.collection("users").document(id).collection("friendRequests").document(currentUser).setData([
            "timeStamp":timeStamp,
            "firstName":CurrentUser.getCurrentUser().getFirstName(),
            "lastName":CurrentUser.getCurrentUser().getLastName()
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
    }
    
    func setUpUI() {
        relationButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = profileImageView.frame.width
        profileImageView.image = UIImage(named: "profile")
        
        guard let user = self.user else {
            print("NO USER")
            return
        }
        let name = user.getFirstName() + " " + user.getLastName()
        print("NAME: " + name)
        self.navigationItem.title = name
        
        let firstName = user.getFirstName()
        
        if(firstName == "Brent") {
            profileImageView!.image = UIImage(named: "BrentBurns.jpg")
        } else if (firstName == "Evander") {
            profileImageView.image = UIImage(named: "EvanderKane.png")
        } else {
            profileImageView!.image = UIImage(named: "LoganCouture.jpg")
        }
        
        profileImageView.contentMode = .scaleAspectFit
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true        //updateRelation()
    }
    
    func updateRelation() {
        guard let user = self.user else {return}
        switch user.getRelation() {
        case .none:
            relationButton.titleLabel?.text = "Friend"
        case .friend:
            relationButton.titleLabel?.text = "Unfriend"
        case .requestSent:
            relationButton.titleLabel?.text = "Friend Request Sent"
        case .requestReceived:
            relationButton.titleLabel?.text = "Accept Friend Request"
        case .undetermined:
            print("Error: Relation undetermined")
        }
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
