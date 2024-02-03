//
//  TeamsViewModel.swift
//  SportApp
//
//  Created by Basma on 31/01/2024.
//

import Foundation
class TeamsViewModel{
    
    var networkHandler:NetworkProtocol?
    var bindResultToViewController : (()->()) = {}
    var result :TeamsModel? {
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
    func getAllTeamDetails()->TeamsModel{
        return result!
    }
}
