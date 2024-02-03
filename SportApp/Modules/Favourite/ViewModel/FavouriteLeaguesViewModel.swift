//
//  FavouriteLeagues.swift
//  SportApp
//
//  Created by Basma on 01/02/2024.
//

import Foundation
import CoreData
class FavouriteLeaguesViewModel{
    
    var coreDataHandler:CoreDataProtocol?
    var result :[NSManagedObject]?
    init() {
        coreDataHandler = CoreDataHandler()
       
    }
   
    func loadData(){
        
        result = coreDataHandler?.fetchFromCoreData()
      
    }
    func getallLeagues()->[NSManagedObject]{
        return result ?? []
    }
    func deleteLeague(index: Int){
        coreDataHandler?.deleteFromCoreData(index: index)
        
    }
}

