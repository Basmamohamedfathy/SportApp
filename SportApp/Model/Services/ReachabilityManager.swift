//
//  ReachabilityManager.swift
//  SportApp
//
//  Created by Basma on 01/02/2024.
//

import Foundation
import Alamofire

class ReachabilityManager {
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        completion(reachabilityManager?.isReachable ?? false)
    }
}
