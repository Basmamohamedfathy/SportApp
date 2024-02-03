//
//  LeagueDetailsViewModel.swift
//  SportApp
//
//  Created by Basma on 28/01/2024.
//

import Foundation
import CoreData
class LeagueDetailsViewModel{
    
    var networkHandler:NetworkProtocol?
    var coreDataHandler:CoreDataProtocol?
    let model = ReachabilityManager()
    var coreDataResult :[NSManagedObject]?
    var bindResultToViewController : (()->()) = {}
    var result :LeagueDetailsModel? {
        didSet{
            bindResultToViewController()
        }
    }
    
    init(networkHandler: NetworkProtocol?) {
        self.networkHandler = networkHandler
        coreDataHandler = CoreDataHandler()
    }
   
    func loadData(){
        
        networkHandler?.fetchResult(complitionHandler: {[weak self] data in
            self?.result = data
            
        })
    }
    func getLeagueData()->LeagueDetailsModel{
        return result!
    }
    func saveLeague(league:FavouriteLeague){
        coreDataHandler?.saveToCoreData(league: league)
        
    }
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
    func loadDataFromCoreData(){
        
        coreDataResult = coreDataHandler?.fetchFromCoreData()
      
    }
    func getallLeagues()->[NSManagedObject]{
        return coreDataResult ?? []
    }
}

