//
//  UpgradeCell.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/18/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class UpgradeCell: UITableViewCell {
    
    @IBOutlet weak var upgradeImg: UIImageView!
    @IBOutlet weak var upgradeTitle: UILabel!
    @IBOutlet weak var purchaseStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        upgradeImg.layer.cornerRadius = 5.0
        upgradeImg.clipsToBounds = true
    }
    
    func configureCell(image: String, title: String, status: String) {
        let img = UIImage(named: image)
        upgradeImg.image = img
        upgradeTitle.text = title
        purchaseStatus.text = status
    }

}
