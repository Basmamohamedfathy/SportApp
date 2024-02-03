//
//  TeamsViewController.swift
//  SportApp
//
//  Created by Basma on 31/01/2024.
//

import UIKit

class TeamsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var coach: UILabel!
    @IBOutlet weak var stack: UIStackView!
    var indicator : UIActivityIndicatorView?
    var playerCell : TableViewCell?
    var mainCell : TableViewCell?
    var selectedTeam : Int?
    var selectedSport : String?
    var reachability : SportsViewModel?
    var teamsViewModel : TeamsViewModel?
    var teamData :TeamsModel?
    var networkHandler:NetworkProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reachability = SportsViewModel()
        networkHandler = NetworkHandler(url: "\(selectedSport!)/?met=Teams&teamId=\(selectedTeam!)")
        teamsViewModel = TeamsViewModel(networkHandler: networkHandler)
        registerCells()
        setBackground()
        reachability?.checkNetworkReachability { isReachable in
            if isReachable {
                self.setIndicator()
                self.loadData()
                
            } else {
                self.showAlert()
            }
        }
    }
    func loadData(){
        teamsViewModel?.loadData()
        teamsViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.display()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mainTable{
            return 1
        }else{
            return teamData?.result?.first?.players!.count ?? 0
        }
    }
    func display() {
            indicator?.stopAnimating()
            teamData = teamsViewModel?.getAllTeamDetails()
            playersTable.reloadData()
            mainTable.reloadData()
            
        }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .white
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTable{
                mainCell = mainTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
               setUpMainCell(indexPath: indexPath)
               return mainCell!

        }else{
            playerCell = playersTable.dequeueReusableCell(withIdentifier: "Players", for: indexPath) as? TableViewCell
           setUpPlayerCell(indexPath: indexPath)
               return playerCell!
        }
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return (UIScreen.main.bounds.height)/7
  
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        6
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "ok", style: .cancel) { _ in
            self.performSegue(withIdentifier: "Home", sender: self)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func setBackground(){
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        let back : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        playersTable.backgroundView = imageView
        mainTable.backgroundView = back
    }
    func registerCells(){
        playersTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Players")
        mainTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func setUpMainCell(indexPath:IndexPath){
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        mainCell?.backgroundView = imageView
        mainCell?.cellTitle.text = teamData?.result?.first?.team_name
        mainCell?.cellData.text = "Coach Name: \(teamData?.result?.first?.coaches?.first?.coach_name ?? "")"
           let logo =  teamData?.result?.first?.team_logo
           let url = URL(string:logo ?? "")
        mainCell?.cellImg.kf.setImage(with: url,placeholder: UIImage(named: (selectedSport?.appending("Ball"))!))
           mainCell?.selectionStyle = .none
    }
    func setUpPlayerCell(indexPath:IndexPath){
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"images")
            return iv
        }()
        playerCell?.backgroundView = imageView
        playerCell?.layer.borderColor = UIColor.white.cgColor
        playerCell?.layer.borderWidth = 1
        playerCell?.layer.cornerRadius = 10
        playerCell?.clipsToBounds = true
        playerCell?.cellTitle.text = teamData?.result?.first?.players?[indexPath.section].player_name?.appending("   No. ").appending(teamData?.result?.first?.players?[indexPath.section].player_number ?? "")
        playerCell?.cellData.text = teamData?.result?.first?.players?[indexPath.section].player_type
           let logo = teamData?.result?.first?.players?[indexPath.section].player_image
           let url = URL(string:logo ?? "")
        playerCell?.cellImg.kf.setImage(with: url,placeholder: UIImage(named: "player"))
        playerCell?.selectionStyle = .none
        
    }
    
}

