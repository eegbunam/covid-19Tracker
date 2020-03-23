//
//  Constants.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import Foundation

struct Contsants{
    static let countryListCellID   = "countryList"
    
    struct DataServiceConstants {
        
        
        struct Covid19Services {
            static let headers = [
                "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
                "x-rapidapi-key": "c37fe56226msh3c4e1336ca870e8p16b031jsn1b62f6c5dd52"
            ]
            static let generalURL = NSURL(string: "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats")! as URL
            static let countryURL = ""
            static let apiKey = ""
        }
    }
    
}
