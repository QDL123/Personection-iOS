//
//  UserRelation.swift
//  Personection
//
//  Created by Quintin Leary on 1/19/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation

enum UserRelation {
    case none, friend, requestSent, requestReceived, undetermined
}

enum LogEvent {
    case nullCurrentUser, authentication, download, null
}


