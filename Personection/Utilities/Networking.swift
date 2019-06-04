//
//  Networking.swift
//  Personection
//
//  Created by Quintin Leary on 6/3/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation
import Firebase

class Networking {
    
    let db: Firestore
    
    static let instance = Networking()
    
    private init() {
        db = Firestore.firestore()
    }
    
    
}


