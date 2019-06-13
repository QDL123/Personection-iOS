//
//  Extensions.swift
//  Personection
//
//  Created by Quintin Leary on 6/4/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation
import Firebase

extension UIAlertController {
    
    func defaultAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}
