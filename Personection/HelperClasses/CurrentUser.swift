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
    
    //Should be private so that only the getCurrentUser function can access the instance
    //This way it can only be operated on once the proper checks have taken place
    private static var currentUser = CurrentUser()
    
    private override init() {
        super.init()
    }
    
    public static func getCurrentUser() -> CurrentUser {
        //The action of constructing the current user should take place during authentication.
        //The currentUser object has been requested
        //First we need to check if someone is logged in to make sure there is a current user
        if(Auth.auth().currentUser == nil) {
            //There is no currently authenticated user
            //There should be no attempted access to the current user when there is none.
            Log.e(eventType: LogEvent.nullCurrentUser, message: "Attempted to access the curent user when none is currently authenticated.")
        }
        return currentUser
    }
    
    public static func login() {
        /*
        If the current user has already been constructed then this will just cause it to update with information of the
        newly authenticated user. If this is the first time that the app is being opened then the constructor will fire
        causing an empty user to be initialized and the then information will be filled in using the update method.
        */
        currentUser.updateUser()
    }
    //No log out method is necessary because access to the current user instance is cut off when there is no authenticated user because of the check
    //in the getCurrentUser function and the private status of currentUser
    
    func updateUser() {
        guard let UUID = Auth.auth().currentUser?.uid else {
            Log.e(eventType: LogEvent.nullCurrentUser, message: "Attempted to update the user when none is currently authenticated.")
            return
        }
        //Check if the same user as last time is being logged in
        //This will likely oftentimes be the case so it checking
        //will make things more efficient
        if(CurrentUser.currentUser.getID() == UUID) {
            //We are dealing with the same user.
            return
        }
        
        //Set up databas reference to the user info
        let db = Firestore.firestore()
        let reference = db.collection("users").document(UUID)
        
        //Get the user info
        reference.getDocument { (document, error) in
            //Check if each piece of information is present
            if let document = document, document.exists {
                if let data = document.data() {
                    if let first = data["firstName"] as? String, let last = data["lastName"] as? String {
                        //Set user properties based on data
                        super.setFirstName(firstName: first)
                        super.setLastName(lastName: last)
                        super.setID(id: UUID)
                    } else {
                        Log.e(eventType: LogEvent.download, message: "Failed to get some piece of user data during CurrentUser update.")
                    }
                } else {
                    Log.e(eventType: LogEvent.download, message: "No data found in the document during CurrentUser update.")
                }
            } else {
                Log.e(eventType: LogEvent.download, message: "No document found during Current User update.")
            }
        }
    }
    
    func downloadHomeInfo() {
        //List of things to potentially download with the load screen up
        //Current user information //(update user method) (name, id, profile pic) etc.
        //Suggested friends list
        //Plans
    }
}
