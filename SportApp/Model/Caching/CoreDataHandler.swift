//
//  CoreDataHandler.swift
//  SportApp
//
//  Created by Basma on 31/01/2024.
//

import Foundation
import CoreData
import UIKit
protocol CoreDataProtocol{
    
    func fetchFromCoreData()-> [NSManagedObject]
    func saveToCoreData(league:FavouriteLeague)
    func deleteFromCoreData(index:Int) 
    
}
class CoreDataHandler :CoreDataProtocol{
    
    func fetchFromCoreData()-> [NSManagedObject] {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        var leaguesFromCoreData : [NSManagedObject] = []
        
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "LeaguesCoreData")
        do{
            
            leaguesFromCoreData = try context.fetch(fetch)
        }catch {
            
        }
        return leaguesFromCoreData
    }
    func saveToCoreData(league:FavouriteLeague) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let LeagueEntity = NSEntityDescription.entity(forEntityName: "LeaguesCoreData", in:context)
        let leaguedata = NSManagedObject(entity: LeagueEntity!, insertInto: context)
        leaguedata.setValue(league.leagueName, forKey: "leagueName")
        leaguedata.setValue(league.leagueImage, forKey: "leagueImage")
        leaguedata.setValue(league.leagueKey, forKey: "leagueKey")
        leaguedata.setValue(league.sport, forKey: "sport")
            do
            {
                try context.save()
                print("Added!!!")
                
            }catch let error as NSError{
                print(error)
            }
            
        }
    func deleteFromCoreData(index:Int) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let core = fetchFromCoreData()
        context.delete(core[index])
            do
            {
                try context.save()
               print("deleted")
                
            }catch let error as NSError{
                print(error)
            }
            
        }
    
}

