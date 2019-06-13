//
//  PlanCell.swift
//  Personection
//
//  Created by Quintin Leary on 4/13/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    
    @IBOutlet weak var activityLocationLabel: UILabel!
    @IBOutlet weak var timeDateLabel: UILabel!
    @IBOutlet weak var profilesCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.heightAnchor.constraint(equalToConstant: 153).isActive = true
    }

}

extension PlanCell {
    func setCollectionviewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int) {
        profilesCollection.dataSource = dataSourceDelegate
        profilesCollection.delegate = dataSourceDelegate
        profilesCollection.tag = row
        profilesCollection.reloadData()
    }
}
