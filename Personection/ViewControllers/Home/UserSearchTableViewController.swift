//
//  UserSearchTableViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/2/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import InstantSearch
import Firebase

class UserSearchTableViewController: HitsTableViewController {
    
    //Private variables
    var users = [User]()
    //private var searching = false
    
    
    //Mark: IBOutlet Connections
    @IBOutlet weak var tableView: HitsTableWidget!
    
    
    
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
        
        //For Demo
        if(firstName == "Brent") {
            cell.imageView!.image = UIImage(named: "BrentBurns.jpg")
        } else if (firstName == "Evander") {
            cell.imageView!.image = UIImage(named: "EvanderKane.png")
        } else {
            cell.imageView!.image = UIImage(named: "LoganCouture.jpg")
        }
        cell.imageView?.frame.size = CGSize(width: 40, height: 40)
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cell.imageView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cell.imageView!.layer.borderWidth = 1
        cell.imageView!.layer.masksToBounds = false
        cell.imageView!.layer.borderColor = UIColor.black.cgColor
        cell.imageView!.layer.cornerRadius = cell.imageView!.frame.height/2
        cell.imageView!.clipsToBounds = true        /*
        guard let email = hit["email"] as? String else {
            print("Error getting user's email")
            cell.textLabel?.text = "Error getting user's email"
            return cell
        }
 */
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR SEGUE")
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let user = users[selectedRow]
            guard let currentUser = Auth.auth().currentUser?.uid else {
                print("Error: Couldn't get currently authenticated user")
                return
            }
            user.determineRelation(userID: currentUser, destination: segue.destination as! RelationDelegate)
            
            let destination = segue.destination as? UserProfileViewController
    
            destination?.setUser(user: user)        }
        
    }
}
