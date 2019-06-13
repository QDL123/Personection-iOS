//
//  User.swift
//  Personection
//
//  Created by Quintin Leary on 1/8/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class User {
    
    private var firstName:String
    private var lastName:String
    private var id:String
    private var relation:UserRelation
    
    init(firstName: String, lastName: String, id:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.relation = UserRelation.undetermined
    }
    
    init() {
        self.firstName = "noFirstName"
        self.lastName = "noLastName"
        self.id = "noID"
        self.relation = UserRelation.undetermined
    }
    
    //Takes the user object (selectedUser), and an id for another user and determines how they are related from the perspective of the userID (currently authenticated).
    func determineRelation(userID: String, destination: RelationDelegate) {
        /* In the future it might be more efficient to do concurrent calls to retrieve data, but it's unclear how to implement that with out promises which is not something I'm prepared to deal with yet. It also might not be the best strategy because depending on the result of the first call, you might be able to end the function right away which would otherwise waste a concurrent call. */
        
        let db = Firestore.firestore()
        let friendRef = db.collection("users").document(self.id).collection("friends").document(userID)
        friendRef.getDocument( completion: { (document1, error) in
            if let document = document1 {
                if(!document.exists) {
                    //Check friend requests starting with selected user
                    let selectedUserFriendRequestRef = db.collection("users").document(self.id).collection("friendRequests").document(userID)
                    selectedUserFriendRequestRef.getDocument(completion: { (document2, error) in
                        if let document = document2 {
                            if(!document.exists) {
                                guard let currentUserID = Auth.auth().currentUser?.uid else {
                                    print("Couldn't get currently authenticated user")
                                    return
                                }
                                let currentUserFriendRequestRef = db.collection("users").document(currentUserID).collection("friendRequests").document(self.id)
                                currentUserFriendRequestRef.getDocument(completion: { (document3, error) in
                                    if let document = document3 {
                                        if(!document.exists) {
                                            self.relation = UserRelation.none
                                        } else {
                                            self.relation = UserRelation.requestReceived
                                        }
                                    }
                                })
                            } else {
                                self.relation = UserRelation.requestSent
                            }
                        }
                    })
                } else {
                    self.relation = UserRelation.friend
                }
            }
            destination.updateRelation()
        })
        self.relation = UserRelation.undetermined
    }
    
    //Getter Functions
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getFullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func getID() -> String {
        return self.id
    }
    func getRelation() -> UserRelation {
        return self.relation
    }
    
    //SEtter Functions
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func setLastName(lastName: String) {
        self.lastName = lastName
    }
    
    func setID(id: String) {
        self.id = id
    }
    func setRelation(relation: UserRelation) {
        self.relation = relation
    }
}
