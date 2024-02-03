//
//  SportsViewController.swift
//  SportApp
//
//  Created by Basma on 26/01/2024.
//

import UIKit

class SportsViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var sport = [String]()
    var cell : SportsCell?
    var sectionHeader : SportsReusableView?
    let CELLIDENTIFIER = "SportsCell"
    let SECTIONHEADERIDENTIFIER = "SectionHeader"
    var flag : Bool?
    var selectedItem : String?
    
    override func viewWillAppear(_ animated: Bool) {
        
        setBackground()
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        setCollectionViewData()
        flag = true
       
               
    }

     // MARK: - Navigation
    
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

         if let cell = sender as? UICollectionViewCell,
            
                let indexPath = self.collectionView.indexPath(for: cell) {
                 let vc = segue.destination as! LeaguesTableViewController
                 vc.selectedItem = sport[indexPath.row] as String
             }

         }
     
  
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sport.count
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER, for: indexPath) as? SportsCell
        cell?.sportImage.image = UIImage(named: sport[indexPath.row])
        setImageRounded()
        cell?.sportName.text = sport[indexPath.row].capitalized
        return cell ?? UICollectionViewCell()
    }
    
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if flag! {
           return CGSize(width: (UIScreen.main.bounds.width / 2)-8, height: (UIScreen.main.bounds.height / 2.5)-35 )
       }else{
           return CGSize(width: UIScreen.main.bounds.width-30 , height: (UIScreen.main.bounds.height / 5)-30 )
       }
       
    }
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SECTIONHEADERIDENTIFIER, for: indexPath) as? SportsReusableView
        sectionHeader?.screenTitle.text = "Sports"
        return sectionHeader ?? UICollectionReusableView()
        
    }
    
  
    
    @IBAction func changeView(_ sender: Any) {
        flag = !flag!
       collectionView.reloadData()
    }
    
    func setImageRounded(){
        cell?.sportImage.layer.borderWidth = 1
        cell?.sportImage.layer.borderColor = UIColor.white.cgColor
        cell?.sportImage.layer.masksToBounds = false
        cell?.sportImage.layer.cornerRadius = (cell?.sportImage.frame.height)!/8
        cell?.sportImage.clipsToBounds = true
        
    }
    
    func setBackground(){
        
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        self.collectionView?.backgroundView = imageView
    }
    
    func setCollectionViewData(){
        sport = ["football","cricket","basketball","tennis"]
    }
}
