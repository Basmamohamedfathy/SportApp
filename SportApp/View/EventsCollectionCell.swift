//
//  EventsCollectionCell.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit

class EventsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        awayLogo.layer.masksToBounds = false
        awayLogo.layer.cornerRadius = (awayLogo.frame.height)/2
        awayLogo.clipsToBounds = true
        
        
        homeLogo.layer.masksToBounds = false
        homeLogo.layer.cornerRadius = (homeLogo.frame.height)/2
        homeLogo.clipsToBounds = true
    }

}
