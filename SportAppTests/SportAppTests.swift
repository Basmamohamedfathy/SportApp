//
//  SportAppTests.swift
//  SportAppTests
//
//  Created by JETSMobileMini1 on 23/01/2024.
//

import XCTest
@testable import SportApp

final class SportAppTests: XCTestCase {
    var coreDataHandler: CoreDataHandler!
}
// MARK: NetworkHandler Test
extension SportAppTests{
    
    func testFetchResultToPass() {
        let expectation = self.expectation(description: "Network request expectation")
        
        let testURL = "football/?met=Fixtures&leagueId=205&from=2024-01-01&to=2024-12-18"
        let networkHandler = NetworkHandler(url: testURL)
        
        networkHandler.fetchResult { (result: LeagueDetailsModel) in
            
            XCTAssertNotNil(result)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
   
   func testFetchResultToFail() {
       let expectation = self.expectation(description: "Network request expectation")
       
       let testURL = "football/?met=Fixtures&leagueId=&from=2024-01-01&to=2024-12-18"
       let networkHandler = NetworkHandler(url: testURL)
       
       networkHandler.fetchResult { (result: LeagueDetailsModel) in
           
           XCTAssertEqual(result.result.count, 1)
        
           expectation.fulfill()
       }
       
       waitForExpectations(timeout: 30, handler: nil)
   }
}

// MARK: ReachabilityManager Test

extension SportAppTests{
    func testCheckNetworkReachabilityWhenReachable() {
       
        let reachabilityManager = ReachabilityManager()
        

        let expectation = expectation(description: "Network Reachable Expectation")
        
      
        reachabilityManager.checkNetworkReachability { isReachable in
           
            XCTAssertTrue(isReachable, "Network should be reachable")
          
            expectation.fulfill()
        }
        
    
        waitForExpectations(timeout: 5, handler: nil)
    }
}
// MARK: CoreDataHandlerTests Test

extension SportAppTests{
  
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataHandler = CoreDataHandler()
    }

    override func tearDownWithError() throws {
        coreDataHandler = nil
        try super.tearDownWithError()
    }

    func testFetchFromCoreData() {
        let fetchedLeagues = coreDataHandler.fetchFromCoreData()
        XCTAssertNotNil(fetchedLeagues, "Fetching from CoreData failed")
    }

    func testSaveToCoreData() {
        let testLeague = FavouriteLeague(leagueName: "World Cup", sport: "football", leagueImage: "https://apiv2.allsportsapi.com/logo/logo_leagues/28_world-cup.png", leagueKey: 28)
        
        coreDataHandler.saveToCoreData(league: testLeague)
        
        let fetchedLeagues = coreDataHandler.fetchFromCoreData()
        XCTAssertTrue(fetchedLeagues.contains { $0.value(forKey: "leagueName") as? String == "World Cup" }, "Saving to CoreData failed")
    }

    func testDeleteFromCoreData() {
       
        let initialLeagues = coreDataHandler.fetchFromCoreData()
        XCTAssertGreaterThan(initialLeagues.count, 0, "No leagues to delete for the test")
        
        let indexToDelete = 0
        coreDataHandler.deleteFromCoreData(index: indexToDelete)
        
        let afterDeletionLeagues = coreDataHandler.fetchFromCoreData()
        XCTAssertLessThan(afterDeletionLeagues.count, initialLeagues.count, "Deletion from CoreData failed")
    }
}
