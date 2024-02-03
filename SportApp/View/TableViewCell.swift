//
//  TableViewCell.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellData: UILabel!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedImage()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    override func layoutSubviews() {
            super.layoutSubviews()
  contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
         
    }
    func roundedImage(){
        cellImg.layer.masksToBounds = false
        cellImg.layer.cornerRadius = (cellImg.frame.height)/2
        cellImg.clipsToBounds = true
    }
   
    
}
