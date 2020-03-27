//
//  ViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit

protocol CountryListVCDelegate {
    func didclickCountry(stats : response
    )
}

class CountryListVC: UIViewController {
    
    var countryListTableView = UITableView()
    let searchBar = UISearchBar()
    var covidList = [response]()
    //var searchCovidList = [response]()
    var delegate : CountryListVCDelegate?
    var isSearching : Bool = false
    override func viewDidAppear(_ animated: Bool) {
        everythingInternet()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a Country"
        setupnavigationBar()
        configureTableView()
        setupSearchBar()
        
        
        
        
    }
    
    func everythingInternet(){
        DataService.sharedClient.testEndPoint { [weak self](data) in
            guard let data = data else{
                print("not getting data")
                //display view
                fatalError()
            }
            let list = data.response
            self?.covidList = list
            self?.twodarray(response: list)
            genArr.sort(by: {$0[0].country < $1[0].country})
            DispatchQueue.main.async {
                self?.countryListTableView.reloadData()
            }
        }
        
        
    }
    
    func setupnavigationBar(){
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.init(hex: Constants.darkblue)
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: Constants.lightblue)
        let font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(hex: Constants.darkblue) , .font: font , .strokeColor:  UIColor.white]
        search(shouldShow: false)
        
    }
    
    
    @objc func  handleSearchBar(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
        
    }
    
    func setupSearchBar(){
        
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        //searchBar.isTranslucent = false
        //searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
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
    
    
    func twodarray(response : [response]){
        var covidlist = response
        if !covidlist.isEmpty{
            while !covidlist.isEmpty{
                let word = covidlist[0].country
                let letter = word[word.startIndex]
                var singlelist :[response] = []
                singlelist = covidlist.filter({ (response) -> Bool in
                    let anotherword = response.country
                    let closureLetter = anotherword[anotherword.startIndex]
                    return closureLetter == letter
                })
                
                genArr.append(singlelist)
                
                
                covidlist.removeAll { (response) -> Bool in
                    let removed = response.country
                    let removedletter = removed[removed.startIndex]
                    return removedletter == letter
                }
                
                
            }
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
    
    func nextvc(indexpath : IndexPath){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "eachCountryVc") as! EachCountryViewController
        self.delegate = vc
        
        var stats = genArr[indexpath.section][indexpath.row]
        
        if isSearching{
            stats = finalList[indexpath.section][indexpath.row]
        }
        delegate?.didclickCountry(stats: stats)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func shouldShowBarButton(show: Bool){
        if show{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    func search(shouldShow : Bool){
        shouldShowBarButton(show: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
        
    }
    
    func shouldsearchTableView(text : String , response : [response]){
        let covidList = response
        finalList.removeAll()
        var searchCovidList : [response] = []
        if !covidList.isEmpty{
            searchCovidList = covidList.filter({ (response) -> Bool in
                return response.country.prefix(text.count) == text
            })
            finalList.append(searchCovidList)
            
            
        }
        
    }
    
    
    
}


extension CountryListVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            return finalList.count
        }else{
             return genArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let sView = UIView()
        if isSearching{
            
            
            if !finalList[section].isEmpty{
                label.text = finalList[section][0].country[finalList[section][0].country.startIndex].uppercased()
            }else{
                 label.text = ""
            }
            
        }else{
            label.text = genArr[section][0].country[genArr[section][0].country.startIndex].uppercased()
        }
        
        
        label.frame = CGRect(x: 10, y: 13, width: 40, height: 20)
        label.backgroundColor = UIColor.init(hex: Constants.lightblue)
        label.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
        label.textAlignment = .left
        sView.backgroundColor = UIColor.init(hex: Constants.lightblue)
        sView.addSubview(label)
        return sView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return finalList[section].count
        }else{
            return genArr[section].count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageView = UIImageView(image: UIImage(named: "right.png"))
        let cell = countryListTableView.dequeueReusableCell(withIdentifier:  Constants.countryListCellID) as! CountryCell
        if isSearching{
            let stats = finalList[indexPath.section][indexPath.row]
            cell.setCountryName(covidstats: stats)
            cell.setcountryImage(covidstats: stats)
            cell.selectionStyle = .none
            cell.accessoryView = imageView
        }else{
            let stats = genArr[indexPath.section][indexPath.row]
            cell.setCountryName(covidstats: stats)
            cell.setcountryImage(covidstats: stats)
            cell.selectionStyle = .none
            cell.accessoryView = imageView
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        nextvc(indexpath: indexPath)
    }
    
    
}


extension CountryListVC : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        isSearching = false
        countryListTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        
        
        shouldsearchTableView(text: searchText, response: covidList)
        countryListTableView.reloadData()
    }
}
