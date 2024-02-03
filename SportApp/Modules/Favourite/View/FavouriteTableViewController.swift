//
//  FavouriteTableViewController.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit
import CoreData

class FavouriteTableViewController: UITableViewController {
    var favLeaguesViewModel : FavouriteLeaguesViewModel?
    var indicator : UIActivityIndicatorView?
    var allLeagues: [NSManagedObject]?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "leaguesCell")
        drawBackground()
        self.setIndicator()
        favLeaguesViewModel = FavouriteLeaguesViewModel()
        favLeaguesViewModel?.loadData()
        display()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return  allLeagues?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               headerView.backgroundColor = UIColor.clear
               return headerView
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaguesCell", for: indexPath) as! TableViewCell
        setUpCell(cell: cell, indexPath: indexPath)
        return cell
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .white
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func display() {
     indicator?.stopAnimating()
     allLeagues = favLeaguesViewModel?.getallLeagues()
     tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favLeaguesViewModel?.deleteLeague(index: indexPath.section)
            allLeagues?.remove(at: indexPath.section)
            tableView.reloadData()
           
        }
    }
    
    func drawBackground(){
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
       tableView.backgroundView = imageView
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "LeagueDetails", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! LeaguesDetailsCollectionViewController
        vc.selecteSport = allLeagues?[tableView.indexPathForSelectedRow!.section].value(forKey: "sport")  as? String
            vc.selectedItem = allLeagues?[tableView.indexPathForSelectedRow!.section].value(forKey: "leagueKey")  as? Int
            
        
    }
   
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       ( UIScreen.main.bounds.height)/7
    }
    
    func setUpCell(cell:TableViewCell,indexPath:IndexPath){
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"images")
            return iv
        }()
        cell.backgroundView = imageView
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.cellTitle.text = allLeagues?[indexPath.section].value(forKey: "leagueName")  as? String
        let logo = allLeagues?[indexPath.section].value(forKey: "leagueImage") as? String
        let url = URL(string:logo ?? "")
        cell.cellImg.kf.setImage(with: url,placeholder: UIImage(named:"footballBall")!)
        cell.cellData.text = ""
        
    }
}
