//
//  UserSearchController.swift
//  Personection
//
//  Created by Quintin Leary on 6/11/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import InstantSearch
import SwiftyJSON

class UserSearchController: UITableViewController, UISearchResultsUpdating {
    
    let client = Client(appID: "DMRC05KK1I", apiKey: "54efdbade3ca6966c12b855166f6bbde")
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setUpSearchController()
    }
    
    //Search Controller
    func setUpSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        //New search stuff
        updateSearchResults(for: search)
    }
    
    //Mark: Search Controller Conformance
    func updateSearchResults(for searchController: UISearchController) {
        //New search stuff
        //clear old users array
        users.removeAll()
        
        let index = client.index(withName: "users_search")
        index.search(Query(query: ""), completionHandler: { (res, error) -> Void in
            
            if let e = error {
                return Log.e(eventType: LogEvent.download, message: e.localizedDescription)
            }
            
            print("***************************************")
            if let res = res {
                let json = JSON(arrayLiteral: res)
                print(json)
                let hits = json[0]["hits"]
                
                //Print the results
                print("NEW RESULTS")
                for hit in hits {
                    let info = hit.1
                    guard let firstName = info["firstName"].string else {return}
                    guard let lastName = info["lastName"].string else {return}
                    guard let ID = info["objectID"].string else {return}
                    
                    //Print the first name of each hit of the results
                    print(firstName)
                    
                    let user = User(firstName: firstName, lastName: lastName, id: ID)
                    self.users.append(user)
                }
            }
            
            
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        let user = users[indexPath.row]
        
        let firstName = user.getFirstName()
        
        
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
        
        
        cell.textLabel?.text = user.getFullName()
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
