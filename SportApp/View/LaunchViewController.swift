//
//  LaunchViewController.swift
//  SportApp
//
//  Created by Basma on 02/02/2024.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var gif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let giff = UIImage.gifImageWithName("First")
        gif.image = giff
       DispatchQueue.main.asyncAfter(deadline: .now()+3) {
         self.performSegue(withIdentifier: "segue", sender: self)
         }
        
         
         }
  
}
