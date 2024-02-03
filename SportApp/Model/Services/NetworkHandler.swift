//
//  NetworkHandler.swift
//  SportApp
//
//  Created by Basma on 27/01/2024.
//

import Foundation
import Alamofire

protocol NetworkProtocol{
    
    func fetchResult<T:Decodable>(complitionHandler:  @escaping (T) -> Void )
}
class NetworkHandler :NetworkProtocol{
    
    let BASEURL = "https://apiv2.allsportsapi.com/"
    let APIKEY = "&APIkey=ed7e03a480916eb3473e76843b1bfee80247df8e5995c15d4c2a286c57370a58"
    var url : URL?
    
    init(url: String) {
        let urlString = BASEURL + url + APIKEY
        print(urlString)
        self.url = URL(string:urlString)
    }
    func fetchResult<T:Decodable>(complitionHandler: @escaping (T) -> Void ){
        
        guard let newURL = url else{
            
            return
        }
    
        AF.request(newURL).responseData { response in
            switch response.result {
            case .success(let data):
                print("background")
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    complitionHandler(result)
                } catch let error {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
             
            }
        }
    }
}
    
