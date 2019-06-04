//
//  FriendRequestsTableViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/19/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendRequestsTableViewController: UITableViewController {

    var requests = [SimpleUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("friendRequests")
        ref.getDocuments(completion: { (querySnapshot, error) in
            if let snapshot = querySnapshot {
                let documents = snapshot.documents
                for document in documents {
                    guard let firstName = document.data()["firstName"] as? String else {
                        return
                    }
                    guard let lastName = document.data()["lastName"] as? String else {
                        return
                    }
                    let id = document.documentID
                    let user = SimpleUser(firstName: firstName, lastName: lastName, ID: id)
                    self.requests.append(user)
                }
            }
            self.tableView.reloadData()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)

        // Configure the cell...
        let user = requests[indexPath.row]
        let name = user.firstName + " " + user.lastName
        cell.textLabel?.text = name
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "friendRequestDetail" {
            if let vc = segue.destination as? UserProfileViewController {
                vc.segueName = segue.identifier
                let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                let simpleUser = requests[(indexPath?.row)!]
                let user = User(firstName: simpleUser.firstName, lastName: simpleUser.lastName, id: simpleUser.ID)
                vc.setUser(user: user)
            }
        }
    }
}
