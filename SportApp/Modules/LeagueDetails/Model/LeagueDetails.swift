//
//  LeagueDetails.swift
//  SportApp
//
//  Created by Basma on 28/01/2024.
//

import Foundation


class LeagueDetails :Decodable{
    
    var event_date :String?
    var event_time :String?
    var event_home_team :String?
    var event_away_team :String?
    var home_team_key :Int?
    var away_team_key :Int?
    var home_team_logo :String?
    var away_team_logo :String?
    var event_final_result :String?
    var league_name :String?
    var league_logo :String?

    
}


struct LeagueDetailsModel :Decodable{
    var result : [LeagueDetails]
}
