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

class UserSearchTableViewController: UIViewController, HitsTableViewDataSource, HitsTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //Suggesstions table delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell") as! UITableViewCell
        cell.textLabel?.text = suggestions[indexPath.row].getFullName()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "People you might know"
    }
    
    let client = Client(appID: "DMRC05KK1I", apiKey: "54efdbade3ca6966c12b855166f6bbde")
    
    var searching: Bool = false
    
    var suggestions = [User]()
    
    
    //Mark: IBOutlet Connections
    @IBOutlet weak var tableView: HitsTableWidget!
    @IBOutlet weak var searchBarWidget: SearchBarWidget!
    
    
    var searchViewModel: SearchViewModel!
    var hitsController: HitsController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitsController = HitsController(table: tableView)
        //tableView.dataSource = hitsController
        //tableView.delegate = hitsController
        hitsController.tableDataSource = self
        hitsController.tableDelegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchViewModel = SearchViewModel(view: searchBarWidget)
        InstantSearch.shared.register(viewModel: searchViewModel)
        searchBarWidget.delegate = self
        searchBarWidget.placeholder = "Search for users..."
        
        //Initialize suggestions
        suggestions.append(User(firstName: "Timo", lastName: "Meier", id: "meierID"))
        suggestions.append(User(firstName: "Tomas", lastName: "Hertl", id: "HertlID"))
        tableView.reloadData()
    
        // Register all widgets in view to InstantSearch
        InstantSearch.shared.registerAllWidgets(in: self.view)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0) {
            searching = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        } else if(searchText.count > 0) {
            searching = true
            tableView.dataSource = hitsController
            tableView.delegate = hitsController
            searchViewModel.search(query: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // ViewController.swift
    //Mark: TableView Delegate Functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        //performSegue(withIdentifier: "toUserDetail", sender: self)
    }
    
    func viewForNoResults(in tableView: UITableView) -> UIView {
        // Specify a View when no results are returned from Algolia
        if(!searching) {
            return UIView()
        }
        return NoResultsView()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        
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

class NoResultsView: UIView {
    
    var shouldSetUpConstraints = true
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "No Results"
        l.font = l.font.withSize(21)
        l.textAlignment = NSTextAlignment.center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetUpConstraints) {
            setUpConstraints()
        }
        super.updateConstraints()
    }
    
    func setUpConstraints() {
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        shouldSetUpConstraints = false
    }
}
