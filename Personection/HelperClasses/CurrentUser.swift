//
//  CurrentUser.swift
//  Personection
//
//  Created by Quintin Leary on 1/18/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//
import Foundation
import Firebase
import FirebaseFirestore

class CurrentUser: User {

    static var currentUser = CurrentUser()
    static var constructed = false
    
    private override init() {
        super.init()
        CurrentUser.constructed = true
        //updateUser()
    }
    
    func updateUser() {
        let UUID = Auth.auth().currentUser?.uid
        //Check if the same user as last time is being logged in
        //This will likely oftentimes be the case so it checking
        //will make things more efficient
        if(CurrentUser.currentUser.getID() == UUID) {
            //We are dealing with the same user.
        }
        let db = Firestore.firestore()
        let reference = db.collection("users").document(UUID!)
        
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let first = data["firstName"] as? String, let last = data["lastName"] as? String {
                        /* OK so in an ideal world we would some how delay constructing the currentUser option until the async completion block finishes, but the super constructor has to be called on the main thread. This means that the current user is construcuted and the function terminates before the user data is found. It may be possible to modify the object as the completion block finishes, the only issue is there is no way to tell whatever is using the object to recheck its values, which means, the object has to be constructed before its needed. Perhaps a good place would be the orientationVC when the user is authenticated. This new method means that trying to assign values in the completion block to a higher scope is futile, but for now I'll leave it as is.
                         Actually it turns out there is no way to call functions on an object from inside it's constructor.
                         */
                        super.setFirstName(firstName: first)
                        super.setLastName(lastName: last)
                        super.setID(id: UUID!)
                    } else {
                        print("ERROR: Failed to get some piece of user data")
                    }
                } else {
                    print("ERROR: No data found in the document")
                }
            } else {
                print("ERROR: No document found")
            }
        }
    }
}
