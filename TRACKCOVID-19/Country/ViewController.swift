//
//  ViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var countryListTableView = UITableView()
    var covidList = [CovidStats]()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a Country"
        configureTableView()
        DataService.sharedClient.getAllCountryData { [weak self] (data) in
            guard let data = data else { return }
            self?.covidList = data.covid19Stats
            DispatchQueue.main.async {
                self?.countryListTableView.reloadData()
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    func configureTableView(){
        view.addSubview(countryListTableView)
        countryListTableView.delegate = self
        countryListTableView.dataSource = self
        countryListTableView.rowHeight = 100
        countryListTableView.pin(to: view)
        countryListTableView.register(CountryCell.self, forCellReuseIdentifier:  Contsants.countryListCellID)
        
    
    }
  


}


extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covidList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryListTableView.dequeueReusableCell(withIdentifier:  Contsants.countryListCellID) as! CountryCell
        let stats = covidList[indexPath.row]
        
        cell.setCountryName(covidstats: stats)
        cell.setcountryImage(covidstats: stats)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = covidList[indexPath.row]
        print(name)
        
    }
    
    
}
