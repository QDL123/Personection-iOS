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

class UserSearchTableViewController: HitsTableViewController, UISearchBarDelegate {
    
    let client = Client(appID: "DMRC05KK1I", apiKey: "54efdbade3ca6966c12b855166f6bbde")
    
    var searching: Bool = false
    
    //Mark: IBOutlet Connections
    @IBOutlet weak var tableView: HitsTableWidget!
    
    @IBOutlet weak var searchBarWidget: SearchBarWidget!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitsTableView = tableView
        
        
        //The search widget delegate has to be assigned to the internal instant search infrastructure so
        //there's no way to get hooks into the search bar events.
        //searchBarWidget.delegate = self
        
    
        // Register all widgets in view to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)
        //Crashlytics.sharedInstance().crash()

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Check if the search bar is empty
        if(searching && searchText.count == 0) {
            //Switch to not searching
            searching = false
        } else if(!searching && searchText.count == 1) {
            searching = true
        }
    }
    
    // ViewController.swift
    //Mark: TableView Delegate Functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath) as! HitCell
        
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
        cell.imageView!.clipsToBounds = true
        
        let user = User(firstName: firstName, lastName: lastName, id: id)
        cell.user = user
        cell.textLabel?.text = (firstName + " " + lastName)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR SEGUE")
        
        //Check what segue is taking place
        if(segue.identifier == "toUserDetail") {
            //The segue is getting details on a particular user from the search
            //Get the index of the cell that was selected
            if let indexPath = tableView.indexPathForSelectedRow {
                
                //Get the cell at that index
                let cell = tableView.cellForRow(at: indexPath) as! HitCell
                
                //Get the destination of the segue
                let destination = segue.destination as? UserProfileViewController
                guard let user = cell.user else {
                    return Log.e(eventType: LogEvent.nullCurrentUser, message: "Hit cell contains no user object")
                }
                destination?.setUser(user: user)
            }
        }
    }
}
