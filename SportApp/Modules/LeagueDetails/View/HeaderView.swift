//
//  HeaderView.swift
//  SportApp
//
//  Created by Basma on 01/02/2024.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    var title :String?{
        didSet{
            titleLabel.text = title
        }
    }
    
}
