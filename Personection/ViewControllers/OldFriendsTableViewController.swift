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
import SwiftyJSON

class FriendsTableViewController: HitsTableViewController, UISearchBarDelegate {
    
    //Mark: Class variables
    //let client = Client(appID: "DMRC05KK1I", apiKey: "54efdbade3ca6966c12b855166f6bbde")
    //let indexName = "users_search"
    
    
    //Mark: IBOutlet Connections
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: HitsTableWidget!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.delegate = self
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        
        hitsTableView = tableView
        // Register all widgets in view to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)

        
        
        //Set up Algolia Search
        //setUpSearch()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setUpSearch() {
        /*
        let jsonURL = Bundle.main.url(forResource: indexName, withExtension: "json")
        let jsonData = try! Data(contentsOf: jsonURL!)
        let dict = try! JSONSerialization.jsonObject(with: jsonData)
        */
        // Load all objects in the JSON file into an index named "contacts".
        //index?.addObjects(dict as! [[String : Any]])
        //search()
    }
    
    //Mark: Search Bar delegate functions
    /*
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        <#code#>
    }
 */
   /*
    func search() {
        print("search")
        let index = client.index(withName: indexName)
        index.search(Query(query: searchBar.text), completionHandler: { (content, error) -> Void in
            print("Should query")
            if error == nil {
                //print("Result: \(content!)")
                if let content = content {
                    let json = JSON(content)
                    print(json)
                    print("Worked?!")
                    self.updateDataSource(json: json)
                } else {
                    print("Content was nil")
                }
            } else {
                print("Error in search results")
            }
        })
    }
 */
    
    func updateDataSource(json: JSON) {
        if let nbHits = json["nbHits"].int {
            for i in (0...nbHits - 1) {
                print(i)
                print(json[i]["firstName"])
            }
        }
    }
    
 /*
    func downloadUsers() {
        
    }
 */
    
    //Mark: Search delegate functions
    

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */

    
    // ViewController.swift
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
