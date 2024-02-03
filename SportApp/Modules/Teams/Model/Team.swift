//
//  Team.swift
//  SportApp
//
//  Created by Basma on 31/01/2024.
//

import Foundation
struct Team :Decodable{
    var team_name :String?
    var team_logo :String?
    var players :[Player]?
    var coaches :[coach]?
}
struct Player :Decodable{
    var player_name :String?
    var player_number :String?
    var player_type :String?
    var player_image :String?
}
struct coach :Decodable{
    var coach_name :String?
}
struct TeamsModel :Decodable{
    var result :[Team]?
}

