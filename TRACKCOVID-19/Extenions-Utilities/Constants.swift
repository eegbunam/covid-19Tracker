//
//  Constants.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import Foundation

var generalArray = [[CovidStats]]()
var genArr =  [[response]]()
var unTouchchedGeneralArray = [[CovidStats]]()
struct Constants{
    static let countryListCellID   = "countryList"
    static let lightblue = "#62C4C3"
    static let red = "#D36767"
    static let darkred = "#AA494A"
    static let darkblue = "#3A4249"
    static let errieBlack = "#171719"
    static let lightbrown = "#F2DAAE"
    struct DataServiceConstants {
        
        
        struct Covid19Services {
            static let headers =  [
                "x-rapidapi-host": "covid19-tracker.p.rapidapi.com",
                "x-rapidapi-key": "c37fe56226msh3c4e1336ca870e8p16b031jsn1b62f6c5dd52"
            ]
            static let generalURL = NSURL(string: "https://covid19-tracker.p.rapidapi.com/statistics")! as URL
            static let countryURL = ""
            static let apiKey = ""
        }
    }
    
}
