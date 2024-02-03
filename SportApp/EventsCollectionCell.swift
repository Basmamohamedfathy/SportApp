//
//  EventsCollectionCell.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit

class EventsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        awayLogo.layer.masksToBounds = false
        awayLogo.layer.cornerRadius = (awayLogo.frame.width)/2
        awayLogo.clipsToBounds = true
        
        
        homeLogo.layer.masksToBounds = false
        homeLogo.layer.cornerRadius = (homeLogo.frame.width)/2
        homeLogo.clipsToBounds = true
        
        
        backGround.layer.borderWidth = 1
        backGround.layer.borderColor = UIColor.white.cgColor
        backGround.layer.masksToBounds = false
        backGround.layer.cornerRadius = (awayLogo.frame.width)/2
        backGround.clipsToBounds = true
        
        
      
    }

}
