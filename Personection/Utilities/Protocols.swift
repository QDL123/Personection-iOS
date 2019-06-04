//
//  Protocols.swift
//  Personection
//
//  Created by Quintin Leary on 1/21/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation

protocol RelationDelegate {
    func updateRelation()
}

protocol TimePickerControllerDelegate {
    func passTime(date: Date, start: Bool)
}


