//
//  LeaguesViewModel.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import Foundation
class LeaguesViewModel{
    
    var networkHandler:NetworkProtocol?
    var bindResultToViewController : (()->()) = {}
    let model = ReachabilityManager()
    var result :LeaguesModel? {
        didSet{
            bindResultToViewController()
        }
    }
    
    init(networkHandler: NetworkProtocol?) {
        self.networkHandler = networkHandler
    }
    
    func loadData(){
        
        networkHandler?.fetchResult(complitionHandler: {[weak self] data in
            self?.result = data
            
        })
    }
    func getAllLeagues()->LeaguesModel{
        return result!
    }
    
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}

