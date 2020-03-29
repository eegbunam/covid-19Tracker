//
//  DataService.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import Foundation
import AWSAppSync
import UIKit

class DataService : Decodable {
    
    static let sharedClient = DataService()
    
    
    
    
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
                //let httpResponse = response as? HTTPURLResponse
                //print(httpResponse!)
                
                guard let jsonData = data else{
                    //print("json data was nil")
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
    
    
    
    func testEndPointCountry(Country : String , completion :@escaping ( _ data : casesbydate?) -> ()){
        
        if Country == ""{
            print("no country informationn given")
            return
        }
        
        
        let headers = [
            "x-rapidapi-host": "coronavirus-monitor-v2.p.rapidapi.com",
            "x-rapidapi-key": "c37fe56226msh3c4e1336ca870e8p16b031jsn1b62f6c5dd52"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://coronavirus-monitor-v2.p.rapidapi.com/coronavirus/cases_by_particular_country.php?country=" + Country)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil)
                return
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                
                guard let jsonData = data else{return}
                
                
                do{
                    let decoder = JSONDecoder()
                    let information = try decoder.decode(casesbydate.self ,from: jsonData)
                    
                    let finalinfo = information
                    completion(finalinfo)
                    
                    
                }
                catch{
                    print("couldnt decode data from case by date")
                    completion(nil)
                }
                
                
            }
        })
        
        dataTask.resume()
    }
    
    
    func getStateData(country : String ,completion :@escaping ( _ data : AllAboutCovid?) -> ()){
        let headers = [
            "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
            "x-rapidapi-key": "c37fe56226msh3c4e1336ca870e8p16b031jsn1b62f6c5dd52"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats?country=" + country)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil)
                return
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                
                guard let jsonData = data else{
                    
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                print(json as! [String:Any])
                
                
                do{
                    let decoder = JSONDecoder()
                    let information = try decoder.decode(AllAboutCovid.self ,from: jsonData)
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

struct casesbydate : Codable{
    var country :String
    var stat_by_country : [stat_by_country]
}

struct stat_by_country : Codable{
    var active_cases :String?
    var country_name :String?
    var id :String
    var new_cases :String?
    var new_deaths : String?
    var record_date :String?
    var region :String?
    var serious_critical :String?
    var total_cases :String?
    var total_cases_per1 : String?
    var total_deaths : String
    var total_recovered : String
    var date : Date?
    
    
    func getdate() -> Date?{
        var finaldate : Date?
        if let string = self.record_date{
            let start = string.index(string.startIndex, offsetBy: 0)
            let end = string.index(string.endIndex, offsetBy: -13)
            let range = start..<end
            let substring = string[range]
            let finalDate = String(substring)
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datee = dateFormatter.date(from:finalDate)!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: datee)
            let ffd = calendar.date(from: components)
            finaldate = ffd
            print(finaldate)
            return finaldate
            
        }else{
            return finaldate
        }
        
    }
    static  func removeDuplicateDates(data : [stat_by_country]){
        //let s = data[0].getdate()
        
        
        
    }
    
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//used to get info for first view controller

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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////












//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct AllAboutCovid : Codable{
    var error : Bool
    var statusCode : Int
    var message : String
    var data : CovidInfo
    
}

struct CovidInfo : Codable {
    var covid19Stats : [CovidStats]
    
}


struct CovidStats : Codable , Hashable {
    var province : String
    var country : String
    var lastUpdate : String
    var confirmed : Int
    var deaths : Int
    var recovered : Int
    var keyId : String
    
}

func ==(lhs : CovidStats , rhs : CovidStats) -> Bool{
    return lhs.country == rhs.country
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//func presentPopUp(title : String , message : String) -> MDCAlertController{
//    // Present a modal alert
//    let alertController = MDCAlertController(title: title, message: message)
//    let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
//    alertController.addAction(action)
//
//    return alertController
//}
