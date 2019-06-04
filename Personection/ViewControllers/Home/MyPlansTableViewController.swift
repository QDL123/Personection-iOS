//
//  MyPlansTableViewController.swift
//  
//
//  Created by Quintin Leary on 12/2/18.
//

import UIKit

struct Plan {
    var timeDate: String
    var profiles: [UIImage]
}

class MyPlansTableViewController: UITableViewController {
    
    var plans: [Plan] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        plans = []
        populatePlans()
        tableView.reloadData()
    }
    
    func populatePlans() {
        
        //Get images
        let burns = UIImage(named: "BrentBurns.jpg")
        let kane = UIImage(named: "EvanderKane.png")
        let couture = UIImage(named: "LoganCouture.jpg")
        
        //MakePlans
        let planA = Plan(timeDate: "Monday, April 15th 11:30am - 3:00pm", profiles: [burns!, kane!, couture!])
        let planB = Plan(timeDate: "Wednesday, April 17th 5pm - 10pm", profiles: [kane!])
        let planC = Plan(timeDate: "Friday, April 19th 7pm - 11:30pm", profiles: [kane!, couture!])
        
        //Add to plans
        plans.append(planA)
        plans.append(planB)
        plans.append(planC)
    }
    
    //Mark: IBActions
    @IBAction func createAPlan(_ sender: Any) {
        let createPlanController = TimeSelectionViewController()
        let nav = UINavigationController(rootViewController: createPlanController)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let planCell = cell as? PlanCell else {return}
        planCell.setCollectionviewDataSourceDelegate(self, forRow: indexPath.row)
        planCell.timeDateLabel.text = plans[indexPath.row].timeDate
    }
   

}

extension MyPlansTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //Mark: Collection View Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans[collectionView.tag].profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        cell.profileImageView.image = plans[collectionView.tag].profiles[indexPath.item]
        cell.profileImageView.contentMode = .scaleAspectFit
        cell.profileImageView.layer.borderWidth = 1
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.borderColor = UIColor.black.cgColor
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
        cell.profileImageView.clipsToBounds = true
        return cell
    }
}
