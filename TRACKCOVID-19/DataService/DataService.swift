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
    
    func getAllCountryData(completion :@escaping ( _ data : cList?) -> ()){
        let headers = Constants.DataServiceConstants.Covid19Services.headers
        let request = NSMutableURLRequest(url: Constants.DataServiceConstants.Covid19Services.generalURL ,
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
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                print(json as! [String:Any])
                do{
                    let decoder = JSONDecoder()
                    let information = try decoder.decode(cList.self ,from: jsonData)
                    let finalinfo = information
                    completion(finalinfo)
                    
                }catch{
                    print("couldnt decode data")
                    completion(nil)
                }
                
                
                
                
            }
        })
        
        dataTask.resume()
        
    }
    
    
    func testEndPoint(completion :@escaping ( _ data : Covid?) -> ()){
        let headers = [
            "x-rapidapi-host": "covid-193.p.rapidapi.com",
            "x-rapidapi-key": "c37fe56226msh3c4e1336ca870e8p16b031jsn1b62f6c5dd52"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-193.p.rapidapi.com/statistics")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                
                guard let jsonData = data else{
                    print("json data was nil")
                    //completion(nil)
                    return
                }
                

                do{
                    let decoder = JSONDecoder()
                    let information = try decoder.decode(Covid.self ,from: jsonData)
                    let finalinfo = information
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


struct Covid : Codable{
    var get : String
    var results : Int
    var response : [response]
    
}

struct response : Codable {
    var country : String
    var cases : cases
    var deaths : deaths
    var time : String
    
    
}

struct cases : Codable {
    var new : String?
    var active : Int
    var critical : Int
    var recovered : Int
    var total : Int
}

struct deaths : Codable{
    var new : String?
    var total : Int
}










struct cList : Codable{
    var location : [location]
}

struct location : Codable{
    var country : String
    var country_code : String
    var latest : [latest]
    var province : String
    
}


struct latest : Codable{
    var confirmed : Int
    var deaths :Int
    var recovered : Int
    
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


struct CovidStats : Codable , Hashable {
    var province : String
    var country : String
    var lastUpdate : String
    var confirmed : Int
    var deaths : Int
    var recovered : Int
    
}

func ==(lhs : CovidStats , rhs : CovidStats) -> Bool{
    return lhs.country == rhs.country
}

