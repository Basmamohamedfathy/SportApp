//
//  Leagues.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import Foundation
class Leagues :Decodable{
    var league_key :Int?
    var league_name :String?
    var league_logo :String?
}
struct LeaguesModel :Decodable{
    var result : [Leagues]
}
