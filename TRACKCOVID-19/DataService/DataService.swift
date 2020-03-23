//
//  DataService.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import Foundation
import AWSAppSync

class DataService : Decodable {
    
   static let sharedClient = DataService()
    
    func getAllCountryData(completion :@escaping ( _ data : CovidInfo?) -> ()){
        let headers = Contsants.DataServiceConstants.Covid19Services.headers
        let request = NSMutableURLRequest(url: Contsants.DataServiceConstants.Covid19Services.generalURL ,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(nil)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                guard let jsonData = data else{
                    print("json data was nil")
                    completion(nil)
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    let information = try decoder.decode(AllAboutCovid.self ,from: jsonData)
                    let finalinfo = information.data
                    completion(finalinfo)

                }catch{
                    print("couldnt decode data")
                    completion(nil)
                }
                
                
                
                
            }
        })

        dataTask.resume()
        
    }
    
    
}
struct AllAboutCovid : Codable{
    var error : Bool
    var statusCode : Int
    var message : String
    var data : CovidInfo
    
}

struct CovidInfo : Codable {
    var lastChecked : String
    var covid19Stats : [CovidStats]
    
    
}


struct CovidStats : Codable {
    var province : String
    var country : String
    var lastUpdate : String
    var confirmed : Int
    var deaths : Int
    var recovered : Int
    
}
