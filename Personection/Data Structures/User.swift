//
//  User.swift
//  Personection
//
//  Created by Quintin Leary on 1/8/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation

class User {
    
    private var firstName:String
    private var lastName:String
    private var email:String
    private var id:String
    
    init(firstName: String,lastName: String, email: String, id:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
    
    init() {
        self.firstName = "noFirstName"
        self.lastName = "noLastName"
        self.email = "noEmail"
        self.id = "noID"
    }
    
    //Getter Functions
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getID() -> String {
        return self.id
    }
    
    //SEtter Functions
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func setLastName(lastName: String) {
        self.lastName = lastName
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func setID(id: String) {
        self.id = id
    }
}
