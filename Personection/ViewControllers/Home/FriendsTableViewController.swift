//
//  FriendsTableViewController.swift
//  Personection
//
//  Created by Quintin Leary on 12/17/18.
//  Copyright © 2018 Quintin Leary. All rights reserved.
//

import UIKit
import Firebase
import InstantSearch

class FriendsTableViewController: HitsTableViewController {
    
    //Private variables
    var users = [User]()
    var user: User?
    
    //Mark: IBOutlet Connections
    @IBOutlet var tableView: HitsTableWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsTableView = tableView
        // Register all widgets in view to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)
    }

    
    // ViewController.swift
    //Mark: TableView Delegate Functions
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
        
        guard let id = hit["objectID"] as? String else {
            print("Error getting user id")
            cell.textLabel?.text = "Error getting user's id"
            return cell
        }
        
        let user = User(firstName: firstName, lastName: lastName, id: id)
        self.users.append(user)
        cell.textLabel?.text = firstName + " " + lastName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        self.user = users[indexPath.row]
        print("hit \(String(describing: hit["firstName"]!)) has been clicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR SEGUE")
        let destination = segue.destination as? UserProfileViewController
        guard let user = self.user else {
            print("NO USER 1")
            return
        }
        print("USER firstName: " + user.getFirstName())
        destination?.setUser(user: user)
    }
}
