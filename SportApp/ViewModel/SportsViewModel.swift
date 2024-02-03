//
//  SportsViewModel.swift
//  SportApp
//
//  Created by Basma on 02/02/2024.
//

import Foundation
class SportsViewModel {
      let model = ReachabilityManager()

    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}
