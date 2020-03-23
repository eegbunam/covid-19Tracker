//
//  ViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit

class CountryListVC: UIViewController {
    
    var countryListTableView = UITableView()
    var covidList = [CovidStats]()
    var generalArray = [[CovidStats]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a Country"
        setupnavigationBar()
        
        configureTableView()
        DataService.sharedClient.getAllCountryData { [weak self] (data) in
            guard let data = data else { return }
            self?.covidList = data.covid19Stats
            self?.covidList.sort(by: {$0.country < $1.country})
            self?.generate2Darray()
            //generalArray.sort(by: {$0[0].country < $1[0].country})
            DispatchQueue.main.async {
                self?.countryListTableView.reloadData()
            }
            
        }
        
    }
    
    func setupnavigationBar(){
        
        navigationController?.navigationBar.backgroundColor = UIColor.init(hex: Constants.darkblue)
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.barTintColor = UIColor.black
        let font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white , .font: font , .strokeColor:  UIColor.white]
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func removeAllDuplicates(stats : [CovidStats])-> [CovidStats]{
        var copyofstats = stats
        var addedDict : [CovidStats:Bool] = [:]
        var finalarray = [CovidStats]()
        while !copyofstats.isEmpty{
            let caseToFind = copyofstats[0]
            
            if addedDict[caseToFind] != true{
                addedDict[caseToFind] = true
            }else{
                copyofstats.removeAll { (stats) -> Bool in
                    return stats.country == caseToFind.country
                }
            }
            
            
        }
        
        for (key,_) in addedDict{
            finalarray.append(key)
        }
        
        return finalarray
    }
    func generate2Darray(){
        var covidListCopy = covidList
        if !covidListCopy.isEmpty{
            while !covidListCopy.isEmpty{
                let word = covidListCopy[0].country
                let letter = word[word.startIndex]
                var singleCovidarray = [CovidStats]()
                singleCovidarray = covidListCopy.filter({ (stats) -> Bool in
                    let anotherword = stats.country
                    let closureLetter = anotherword[anotherword.startIndex]
                    return closureLetter == letter
                })
                //filter array here
                let finalsingle = removeAllDuplicates(stats: singleCovidarray)
                generalArray.append(finalsingle)
                
                covidListCopy.removeAll { (stats) -> Bool in
                    let removed = stats.country
                    let removedletter = removed[removed.startIndex]
                    return removedletter == letter
                    
                    
                }
                
                
                
                
                
            }
        }else{
            fatalError()
        }
    }
    
    
    
    func configureTableView(){
        view.addSubview(countryListTableView)
        countryListTableView.delegate = self
        countryListTableView.dataSource = self
        countryListTableView.rowHeight = 100
        countryListTableView.pin(to: view)
        countryListTableView.register(CountryCell.self, forCellReuseIdentifier:  Constants.countryListCellID)
        
        
    }
    
    
    
}


extension CountryListVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return generalArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return generalArray[section][0].country[generalArray[section][0].country.startIndex].uppercased()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let sView = UIView()
        
        label.text = generalArray[section][0].country[generalArray[section][0].country.startIndex].uppercased()
        
        label.frame = CGRect(x: 10, y: 13, width: 40, height: 20)
        label.backgroundColor = UIColor.init(hex: Constants.darkblue)
        label.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
        label.textAlignment = .left
        sView.backgroundColor = UIColor.init(hex: Constants.darkblue)
        sView.addSubview(label)
        return sView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return generalArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryListTableView.dequeueReusableCell(withIdentifier:  Constants.countryListCellID) as! CountryCell
        let stats = generalArray[indexPath.section][indexPath.row]
        
        cell.setCountryName(covidstats: stats)
        cell.setcountryImage(covidstats: stats)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = generalArray[indexPath.section][indexPath.row]
        print(name)
        
    }
    
    
}
