//
//  LeaguesTableViewController.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit
import Kingfisher
class LeaguesTableViewController: UITableViewController {
    
    var indicator : UIActivityIndicatorView?
    var leaguesViewModel : LeaguesViewModel?
    var networkHandler:NetworkProtocol?
    var allLeagues : LeaguesModel?
    var selectedItem : String?
    var cell : TableViewCell?
    let CELLIDENTIFIER = "leaguesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkHandler = NetworkHandler(url: "\(selectedItem!)/?met=Leagues")
        leaguesViewModel = LeaguesViewModel(networkHandler: networkHandler)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: CELLIDENTIFIER)
       
       setBackground()
        leaguesViewModel?.checkNetworkReachability { isReachable in
            if isReachable {
                self.setIndicator()
                self.getTableData()
            } else {
                self.showAlert()
            }
            
        }
        
    }
  
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allLeagues?.result.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: CELLIDENTIFIER, for: indexPath) as? TableViewCell
        cellHandeling(indexPath: indexPath)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        6
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               headerView.backgroundColor = UIColor.clear
               return headerView
       
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        performSegue(withIdentifier: "LeagueDetails", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LeagueDetails"{
            let vc = segue.destination as! LeaguesDetailsCollectionViewController
            vc.selecteSport = selectedItem
            vc.selectedItem = allLeagues?.result[tableView.indexPathForSelectedRow!.section].league_key
            
        }
        
    }
   
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ( UIScreen.main.bounds.height)/7
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
     allLeagues = leaguesViewModel?.getAllLeagues()
     tableView.reloadData()
        
    }
    func cellHandeling(indexPath :IndexPath){
        let logo = allLeagues?.result[indexPath.section].league_logo
        let url = URL(string:logo ?? "")
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"images")
            return iv
        }()
        cell?.backgroundView = imageView
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 10
        cell?.clipsToBounds = true
        cell?.cellImg.kf.setImage(with: url,placeholder: UIImage(named: (selectedItem?.appending("Ball"))!))
        cell?.cellTitle.text = allLeagues?.result[indexPath.section].league_name
        cell?.cellData.text = ""
    }
    func setBackground(){
        
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        self.tableView.backgroundView = imageView
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "ok", style: .cancel) { _ in
            self.performSegue(withIdentifier: "Home", sender: self)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func getTableData(){
        
        leaguesViewModel?.loadData()
        leaguesViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.display()
            }
        }
    }
}

