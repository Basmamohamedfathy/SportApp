//
//  LeaguesDetailsCollectionViewController.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import UIKit
import CoreData
class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var indicator : UIActivityIndicatorView?
    var selectedItem : Int?
    var selecteSport : String?
    var selectedteam : Int?
    var upcomingEvents : LeagueDetailsModel?
    var leagueDetailsViewModelUpComingEvents : LeagueDetailsViewModel?
    var lastEvents : LeagueDetailsModel?
    var reachability : SportsViewModel?
    var leagueDetailsViewModelLastEvents : LeagueDetailsViewModel?
    var networkHandlerLastResult:NetworkProtocol?
    var networkHandlerUpComingResult:NetworkProtocol?
    var currentDate : String?
    var nextDate : String?
    var lastDate : String?
    var resultCount = 0
    var teams :[(Int?,String?)]?
    var favouriteLeague:FavouriteLeague?
    var allLeagues: [NSManagedObject]?
    
    override func viewWillAppear(_ animated: Bool) {
        getDates()
        registerAllCells()
        drawBackground()
        reachability = SportsViewModel()
        let layout = UICollectionViewCompositionalLayout{index, environment in
            switch index {
            case 0:
                return self.drawUpComingEventsSection()
            case 1:
                return self.drawLastEventSection()
            default:
                
                return self.drawTheTeamsSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
        reachability?.checkNetworkReachability { isReachable in
            if isReachable {
                self.setIndicator()
                self.getLastEventsSectionData()
                self.getUpcomingEventsSectionData()
                
            } else {
                self.showAlert()
            }
            
        }
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "header",
                                                                   withReuseIdentifier: "HeaderView",for: indexPath) as! HeaderView
        switch indexPath.section {
        case 0:
            view.title = "Upcoming events"
        case 1:
            view.title = "Last events"
        default:
            view.title = "Teams"
        }
        
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedteam = teams?[indexPath.row].0
        if selecteSport == "football"{
            performSegue(withIdentifier: "TeamDetails", sender: self)
         
        }
        
    }
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamDetails"{
            let vc = segue.destination as! TeamsViewController
            vc.selectedSport = self.selecteSport
            vc.selectedTeam = selectedteam
        }
        
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(section){
        case 0 : upcomingEvents?.result.count ?? 0
        case 1 : resultCount
        default:teams?.count ?? 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventsCollectionCell
            
            lastEventsCell(cell: cell, indexPath: indexPath)
            
            return cell
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamsCollectionCell
            
            teamsCell(cell: cell, indexPath: indexPath)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventsCollectionCell
          
            upComingEventsCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
    }
    func animation(section : NSCollectionLayoutSection){
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .white
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func getDates(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         currentDate = dateFormatter.string(from: Date())
         nextDate = dateFormatter.string(from:Calendar.current.date(byAdding: .month, value: 6, to: Date())!)
         lastDate = dateFormatter.string(from:Calendar.current.date(byAdding: .month, value: -6, to: Date())!)
      
    }
    @IBAction func addToFavourite(_ sender: Any) {
        
        favouriteLeague = FavouriteLeague(leagueName: lastEvents?.result.first?.league_name ?? "", sport: selecteSport ?? "", leagueImage: lastEvents?.result.first?.league_logo ?? "", leagueKey: selectedItem ?? 0)
        leagueDetailsViewModelLastEvents?.loadDataFromCoreData()
        display()
        var count = 0
        for item in 0..<(allLeagues?.count ?? 0) {
            if ((allLeagues?[item].value(forKey: "leagueKey")) as! Int == selectedItem!) {
                count = 1
            }
            
        }
        switch count{
        case 0:
            leagueDetailsViewModelLastEvents?.saveLeague(league: favouriteLeague!)
        default:
            break
        }
        
    }
    
    func display() {
     allLeagues = leagueDetailsViewModelLastEvents?.getallLeagues()
    }
    func registerAllCells(){
        collectionView.register(UINib(nibName: "EventsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
        collectionView.register(UINib(nibName: "TeamsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TeamCell")
        collectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
 
    }
    func drawBackground(){
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"background")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        self.collectionView.backgroundView = imageView
        
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "ok", style: .cancel) { _ in
            self.performSegue(withIdentifier: "Home", sender: self)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
// MARK: Last Events Section

extension LeaguesDetailsCollectionViewController{
    
    func drawLastEventSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              , heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                               , heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
                                                     , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10
                                                        , bottom: 10, trailing: 10)
        let header  = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func getLastEventsSectionData(){
        networkHandlerLastResult = NetworkHandler(url: "\(selecteSport!)/?met=Fixtures&leagueId=\(selectedItem!)&from=\(lastDate ?? "2022-01-01")&to=\(currentDate ?? "2024-01-01")")
        leagueDetailsViewModelLastEvents = LeagueDetailsViewModel(networkHandler: networkHandlerLastResult)
        leagueDetailsViewModelLastEvents?.loadData()
        leagueDetailsViewModelLastEvents?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.displayLastEvents()
            }
        }
        
    }
  
    func displayLastEvents() {
        indicator?.stopAnimating()
        lastEvents = leagueDetailsViewModelLastEvents?.getLeagueData()
         teams = lastEvents?.result.map {
            team in return (team.home_team_key,team.home_team_logo)
            
        }
       resultCount = 5
        collectionView.reloadData()
        
    }
    func lastEventsCell(cell: EventsCollectionCell,indexPath : IndexPath){
        cell.homeLogo.kf.setImage(with: URL(string:lastEvents?.result[indexPath.row].home_team_logo ?? ""),placeholder: UIImage(named: (selecteSport?.appending("Ball"))!))
        cell.awayLogo.kf.setImage(with: URL(string:lastEvents?.result[indexPath.row].away_team_logo ?? ""),placeholder: UIImage(named: (selecteSport?.appending("Ball"))!))
        cell.homeName.text = lastEvents?.result[indexPath.row].event_home_team
        cell.awayName.text = lastEvents?.result[indexPath.row].event_away_team
        cell.date.text = lastEvents?.result[indexPath.row].event_date?.appending("    ||  ").appending(lastEvents?.result[indexPath.row].event_time ?? "")
            
        cell.result.text = lastEvents?.result[indexPath.row].event_final_result

    }
    
}

// MARK: UpComing Events Section

extension LeaguesDetailsCollectionViewController{
    
    func drawUpComingEventsSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10
                                                        , bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        let header  = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        animation(section: section)
        
        return section
    }
    func getUpcomingEventsSectionData(){
        
        networkHandlerUpComingResult = NetworkHandler(url: "\(selecteSport!)/?met=Fixtures&leagueId=\(selectedItem!)&from=\(currentDate ?? "2024-01-01")&to=\(nextDate ?? "2024-12-18")")
        leagueDetailsViewModelUpComingEvents = LeagueDetailsViewModel(networkHandler: networkHandlerUpComingResult)
        leagueDetailsViewModelUpComingEvents?.loadData()
        leagueDetailsViewModelUpComingEvents?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.displayUpcomingEvents()
            }
        }
        
    }
    func displayUpcomingEvents() {
        indicator?.stopAnimating()
        upcomingEvents = leagueDetailsViewModelUpComingEvents?.getLeagueData()
        collectionView.reloadData()
        
        
        
    }
    func upComingEventsCell(cell: EventsCollectionCell,indexPath : IndexPath){
        
           cell.homeLogo.kf.setImage(with: URL(string:upcomingEvents?.result[indexPath.row].home_team_logo ?? ""),placeholder: UIImage(named: (selecteSport?.appending("Ball"))!))
           cell.awayLogo.kf.setImage(with: URL(string:upcomingEvents?.result[indexPath.row].away_team_logo ?? ""),placeholder: UIImage(named: (selecteSport?.appending("Ball"))!))
           cell.homeName.text = upcomingEvents?.result[indexPath.row].event_home_team
           cell.awayName.text = upcomingEvents?.result[indexPath.row].event_away_team
           cell.date.text = upcomingEvents?.result[indexPath.row].event_date?.appending("    ||  ").appending(upcomingEvents?.result[indexPath.row].event_time ?? "")
           cell.result.text = ""
    }
    
}

// MARK: Teams Section

extension LeaguesDetailsCollectionViewController{
    func drawTheTeamsSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 16, bottom: 16, trailing: 0)
        
        animation(section: section)
        let header  = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    func teamsCell(cell: TeamsCollectionCell,indexPath : IndexPath){
        cell.teamsLogo.kf.setImage(with: URL(string:teams?[indexPath.row].1 ?? ""),placeholder: UIImage(named: (selecteSport?.appending("Ball"))!))
    }

}
