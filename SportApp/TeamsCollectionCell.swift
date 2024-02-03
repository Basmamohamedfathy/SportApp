//
//  TeamsCollectionCell.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit

class TeamsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var teamsLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamsLogo.layer.masksToBounds = false
        teamsLogo.layer.cornerRadius = (teamsLogo.frame.height)/2
        teamsLogo.clipsToBounds = true
       
    }

}
