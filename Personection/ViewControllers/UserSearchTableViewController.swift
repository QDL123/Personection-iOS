//
//  UserSearchTableViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/2/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import InstantSearch

class UserSearchTableViewController: HitsTableViewController {
    
    //Mark: IBOutlet Connections
    @IBOutlet weak var tableView: HitsTableWidget!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTableView = tableView
        // Register all widgets in view to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        guard let firstName = hit["firstName"] as? String else {
            print("Error getting user's first name")
            cell.textLabel?.text = "Error getting user's first name"
            return cell
        }
        guard let lastName = hit["lastName"] as? String else {
            print("Error getting user's last name")
            cell.textLabel?.text = "Error getting user's last name"
            return cell
        }
        
        cell.textLabel?.text = firstName + " " + lastName
        
        return cell
    }

    

}
