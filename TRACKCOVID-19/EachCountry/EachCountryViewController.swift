//
//  EachCountryViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/23/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import ANActivityIndicator
import Charts

class EachCountryViewController: UIViewController {
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    
    @IBOutlet weak var recoveredLabel: UILabel!
    
    
    @IBOutlet weak var activeCasesLabel: UILabel!
    
    @IBOutlet weak var deathsLabel: UILabel!
    var countryInformation : response?
    
    
    @IBOutlet weak var totalCasesLabel: UILabel!
    
    
    
    @IBOutlet weak var recoveredImage: UIImageView!
    
    
    @IBOutlet weak var activeImage: UIImageView!
    
    
    @IBOutlet weak var deathsImage: UIImageView!
    
    
    @IBOutlet weak var totalImage: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var segmentedView: UIView!
    
    @IBOutlet weak var bStack: UIStackView!
    
    var popView = UIView()
    var originalPopUpY : CGFloat?
    
    let font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
    let darkBlue = UIColor(hex: Constants.darkblue)
    
    var lastUpdateTableView = UITableView()
    var ProvinceTableView = UITableView()
    
    var firstList = ["hey","how","hey"]
    var secondList = ["bye","boy","babe", "bbaba"]
    var index : Int = 0
    var dataList : [stat_by_country] = []
    var stateList : [CovidStats] = []
    lazy var  tableViewList : Any = dataList
     let graphView = LineChartView()
    
    override func viewDidLoad() {
        view.isUserInteractionEnabled = false
        
        let width = bottomView.frame.width
        let height = bottomView.frame.height
        let x = (view.frame.width - width)/2
        let y = (view.frame.height - height)/2
        let indicator = ANActivityIndicatorView(frame: CGRect(x: x, y: y, width: width, height: height), animationType: .ballZigZagDeflect, color: darkBlue, padding: 0)
        bStack.addSubview(indicator)
        indicator.startAnimating()
        DataService.sharedClient.testEndPointCountry(Country: countryInformation?.country ?? "") { [weak self](data) in
            if let data = data{
                let stats = data.stat_by_country
                self?.dataList = stats
                self?.tableViewList = self!.dataList
                stat_by_country.removeDuplicateDates(data: self!.dataList)
                DispatchQueue.main.async {
                    self?.setUpgraph()
                    self?.lastUpdateTableView.reloadData()
                    indicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                  
                }
            }else{
                print("data is nil")
                indicator.stopAnimating()
                // no data show view
                self?.view.isUserInteractionEnabled = true
            }
            
        }
        
        DataService.sharedClient.getStateData(country: countryInformation?.country ?? "") {[weak self] (covid) in
            if let covid = covid{
                
                if covid.message == "OK"{
                    let data = covid.data.covid19Stats
                    self?.stateList = data
    
                }
                
            }else{
                //show view
                self?.view.isUserInteractionEnabled = true
                
                
            }
        }
        super.viewDidLoad()
        title = countryInformation?.country
        setupView()
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EachCountryViewController : CountryListVCDelegate{
    
    func didclickCountry(stats: response) {
        print("in delegate")
        countryInformation = stats
        
    }
    
    
}
extension EachCountryViewController {
    
    
    
    func setupView(){
        //segmentedView.isHidden = true
        //segmentedView.addSubview(setupsegmantedControl())
        bStack.addSubview(setupsegmantedControl())
        segmentedView.backgroundColor = .white
        //UIColor.init(hex: Constants.lightblue)?.withAlphaComponent(0.8)
        setupdeathView()
        setuprecoveryView()
        setupActiveView()
        setupCountryImage()
        setuptottalView()
        setupTopView()
        setupBottomView()
        setupLastUpdateTableView()
        //setuppopView()
        
        
    }
    
    
    
    
    
    
    
    ////setup graph ////
    
    func setUpgraph(){
        // setupgraph only after datalist is available
    
        bottomView.addSubview(graphView)
        graphView.backgroundColor = .lightGray
        graphView.pin(to: bottomView)
        graphView.tag = 10
        //updateGrpah()
        
    }
    func updateGrpah(){
        var lineChartEntry  = [ChartDataEntry]()
        
        for values in dataList{
            
        }
        
        for i in 0...dataList.count{
            if let y = dataList[i].active_cases?.replacingOccurrences(of: ",", with: ""
                ){
                let newy = Double(y)!
                 let value = ChartDataEntry(x: Double(i), y: newy)
                lineChartEntry.append(value)
            }else{
                print("worng values")
            }
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet

               line1.colors = [NSUIColor.blue] //Sets the colour to blue


               let data = LineChartData() //This is the object that will be added to the chart

               data.addDataSet(line1) //Adds the line to the dataSet
               

               graphView.data = data //finally - it adds the chart data to the chart and causes an update

               graphView.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    
    
    ////end setup graph ////
    
    func setupLastUpdateTableView(){
        bottomView.addSubview(lastUpdateTableView)
        lastUpdateTableView.delegate = self
        lastUpdateTableView.dataSource = self
        lastUpdateTableView.rowHeight = 40
        lastUpdateTableView.pin(to: bottomView)
        //lastUpdateTableView.register(CountryCell.self, forCellReuseIdentifier:  Constants.countryListCellID)
        
    }
    
    
    func setupdeathView(){
        guard let countryInformation = countryInformation else {return}
        
        let deathToll = countryInformation.deaths.total
        let image = UIImage(named: "death.png")
        deathsImage.image = image
        deathsImage.contentMode = .scaleAspectFit
        deathsLabel.text = "Death: \(deathToll)"
        deathsLabel.font = font
        deathsLabel.adjustsFontSizeToFitWidth = true
        deathsLabel.textColor = darkBlue
        
    }
    
    func setuppopView(deathText : String , activeText : String , recovered : String, Province : String){
        let width = view.frame.width / 1.2 - 15
        let height = view.frame.height / 2.5
        let x = (view.frame.width - width)/2
        let y = view.frame.height
        originalPopUpY = y
        popView.frame = CGRect(x: x, y: y, width: width, height: height)
        popView.layer.cornerRadius = 10
        popView.backgroundColor = .white
        popView.layer.shadowColor = UIColor.black.cgColor
        popView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popView.layer.shadowRadius = 0.5
        popView.layer.shadowOpacity = 0.3
        popView.layer.cornerRadius = 10
        view.addSubview(popView)
        
        
        
        
        let genHeight = popView.frame.height / 4.5
        let button = UIButton(frame: CGRect(x: popView.frame.width - 30, y: 0, width: 30, height: 30))
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handlepopcancelButton), for: .touchUpInside)
        button.setImage(UIImage(named: "cancel.png"), for: .normal)
        popView.addSubview(button)
        
        
        let countryLabel = UILabel()
        countryLabel.frame = CGRect(x: 20, y: 0  , width: width - 80 , height: genHeight - 20)
        countryLabel.backgroundColor = .white
        countryLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 20)
        countryLabel.text  = Province
        countryLabel.layer.cornerRadius = 20
        //countryLabel.adjustsFontSizeToFitWidth = true
        popView.addSubview(countryLabel)
        
        
        let activeLabel = UILabel()
        activeLabel.frame = CGRect(x: 20, y: height/4 - 19 , width: width - 35 , height: genHeight)
        activeLabel.backgroundColor = .white
        activeLabel.font = font
        activeLabel.text  = activeText
        activeLabel.layer.cornerRadius = 20
        activeLabel.adjustsFontSizeToFitWidth = true
        popView.addSubview(activeLabel)
        
        
        
        let deathLabel = UILabel()
        deathLabel.frame = CGRect(x: 20, y: activeLabel.frame.origin.y + (popView.frame.height / 4) + 5, width: width - 35 , height: genHeight)
        deathLabel.backgroundColor = .white
        deathLabel.font = font
        deathLabel.text = deathText
        deathLabel.layer.cornerRadius = 10
        deathLabel.adjustsFontSizeToFitWidth = true
        popView.addSubview(deathLabel)
        
        let recoveredLabel = UILabel()
        recoveredLabel.frame = CGRect(x: 20, y: deathLabel.frame.origin.y + (popView.frame.height / 4) + 5 , width: width - 35 , height: genHeight)
        recoveredLabel.backgroundColor = .white
        recoveredLabel.font = font
        recoveredLabel.text = recovered
        recoveredLabel.layer.cornerRadius = 10
        recoveredLabel.adjustsFontSizeToFitWidth = true
        popView.addSubview(recoveredLabel)
        
        
        
        
    }
    
    @objc func handlepopcancelButton(){
        removepopUp()
    }
    
    func displaypopView(){
     
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.popView.frame.origin.y = self.segmentedView.frame.midY
        }, completion: nil)
    }
    
    func removepopUp(){
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            if let y = self.originalPopUpY{
                self.popView.frame.origin.y = y
            }
        }, completion: nil)
        
    }
    
    
    func setuprecoveryView(){
        let recovery = countryInformation?.cases.recovered
        let image = UIImage(named: "recovery.png")
        recoveredImage.image = image
        recoveredImage.contentMode = .scaleAspectFit
        recoveredLabel.font = font
        recoveredLabel.text = "Recovered: \(recovery ?? 0)"
        recoveredLabel.adjustsFontSizeToFitWidth = true
        recoveredLabel.textColor = darkBlue
        
    }
    
    func setupActiveView(){
        let activeNumber = countryInformation?.cases.active
        let image = UIImage(named: "active.png")
        activeImage.image = image
        activeImage.contentMode = .scaleAspectFit
        activeCasesLabel.font = font
        activeCasesLabel.text =  "Active Cases: \(activeNumber ?? 0)"
        activeCasesLabel.adjustsFontSizeToFitWidth = true
        
        activeCasesLabel.textAlignment = .left
        activeCasesLabel.numberOfLines = 2
        activeCasesLabel.clipsToBounds = true
        activeCasesLabel.textColor = darkBlue
        
    }
    
    func setupCountryImage(){
        
        let cName = countryInformation?.country
        let picname = setcountryImage(name: (cName ?? ""))
        print(picname)
        countryFlagImage.image = UIImage(named: picname)
        countryFlagImage.layer.cornerRadius = 10
    }
    
    
    func setuptottalView(){
        
        let total = countryInformation?.cases.total
        totalCasesLabel.text = "Total Infected: \(total ?? 0)"
        totalCasesLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 20)
        totalCasesLabel.adjustsFontSizeToFitWidth = true
        totalCasesLabel.textColor = darkBlue
        
        
    }
    
    func setupsegmantedControl() -> BetterSegmentedControl{
        let width = segmentedView.frame.width - 10
        let x = (view.frame.width - width)/2
        let control = BetterSegmentedControl(
            frame: CGRect(x: segmentedView.frame.origin.x, y: segmentedView.frame.origin.y, width: segmentedView.frame.width , height: segmentedView.frame.height - 10),
            segments: LabelSegment.segments(withTitles: ["Updates", "Province", "Charts"],
                                            normalFont:font,
                                            normalTextColor: darkBlue,
                                            selectedFont:font,
                                            selectedTextColor: .white),
            index: 2,
            options: [.backgroundColor(.white),
                      .indicatorViewBackgroundColor(UIColor.init(hex: Constants.lightblue) ?? UIColor.lightGray),
                      .cornerRadius(15.0)
                ,
                      .animationSpringDamping(0.7),
                      .panningDisabled(true)
        ])
        
        control.addTarget(self, action: #selector(segmentedControlFuntion(_:)), for: .valueChanged)
        return control
        
    }
    
    func removeGraph(){
        
        for view in bottomView.subviews{
            if view.tag == 10{
                view.isHidden = true
                view.removeFromSuperview()
            }
        }
        
    }
    
    
    @objc func segmentedControlFuntion(_ sender : BetterSegmentedControl){
        if sender.index == 0{

            //removeGraph()
            tableViewList = dataList
            index = 0
            lastUpdateTableView.reloadData()
            print(sender.index)
             bottomView.bringSubviewToFront(lastUpdateTableView)
        }
         if sender.index == 1 {
            index = 1
            print("index is 1")
            tableViewList = stateList
            lastUpdateTableView.reloadData()
            print(sender.index)
             bottomView.bringSubviewToFront(lastUpdateTableView)
        }
        
        if sender.index == 2{
            print(sender.index)
           
             bottomView.bringSubviewToFront(graphView)
        }
        
        
    }
    
    
    func setupTopView(){
        //topView.backgroundColor = UIColor.init(hex: Constants.lightblue)?.withAlphaComponent(0.8)
        topView.clipsToBounds = true
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: -1, height: 1)
        topView.layer.shadowRadius = 0.5
        topView.layer.shadowOpacity = 0.3
        topView.layer.cornerRadius = 10
        
    }
    
    func setupBottomView(){
        bottomView.backgroundColor = .white

        
    }
    
    
    func setcountryImage(name : String)-> String{
        var newname = name
        if newname == "USA"{
            newname = "United States"
        }
        if let iso = IsoCountryCodes.searchByName(newname){
            let imagename = iso.alpha2.lowercased() + ".png"
            return imagename
            
        }else{
            return ""
        }
    }
}


extension EachCountryViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0 {
            return (tableViewList as! [stat_by_country]).count
        }else{
            return (tableViewList as! [CovidStats]).count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if index == 0{
            let finalList = tableViewList as! [stat_by_country]
            cell.textLabel?.text = finalList[indexPath.row].record_date
        }else{
            let finalList = tableViewList as! [CovidStats]
            if finalList.count == 1{
                cell.textLabel?.text = finalList[indexPath.row].country
            }else{
                cell.textLabel?.text = finalList[indexPath.row].keyId
               
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if index == 0{
            let finalList = tableViewList as! [stat_by_country]
            let activecases = finalList[indexPath.row].total_cases ?? "0"
            let finalSTotalCase = "At this time there was \(activecases) Total cases"
            
            var deathcase = finalList[indexPath.row].total_deaths
            if deathcase == ""{
                deathcase = "0"
            }
            let finalDeath = "At this time there was \(deathcase) Total Deaths"
            
            let recovered = finalList[indexPath.row].total_recovered
            let finalrecovered = "At this time there was \(recovered) Total Recoveries"
            
            setuppopView(deathText: finalDeath, activeText: finalSTotalCase, recovered: finalrecovered , Province: finalList[indexPath.row].country_name ?? "")
            displaypopView()
            
            
        }else{
            let finalList = tableViewList as! [CovidStats]
             let country = finalList[indexPath.row].country
            let stats = finalList[indexPath.row]
            if finalList.count == 1{
               
    
                let Copnfrimedstring = "There are \(countryInformation?.cases.total ?? 0) confimed cases in \(country)"
                var deathstring = "There are \(countryInformation?.deaths.total ?? 0) confimed deaths in \(country)"
                let deaths = countryInformation?.deaths.total ?? 0
                if deaths == 1 {
                    deathstring = "There is \(deaths) confimed death in \(country)"
                }
                var recoveredstring = "There are \(countryInformation?.cases.recovered ?? 0) confimed recoveries in \(country)"
                let recoveries = countryInformation?.cases.recovered ?? 0
                if  recoveries == 1{
                     recoveredstring = "There is \(recoveries) confimed reovery in \(country)"
                }
                
                setuppopView(deathText: deathstring, activeText: Copnfrimedstring, recovered: recoveredstring , Province: country)
                displaypopView()
                
                
            }else{
                //cell.textLabel?.text = finalList[indexPath.row].province
                let Confrimedstring = "There are \(stats.confirmed) confimed cases in \(stats.province)"
                let deathstring = "There are \(stats.deaths) confimed deaths in \(stats.province)"
                let recoveredstring = "There are \(stats.recovered) confimed recovveries in \(stats.province)"
                setuppopView(deathText: deathstring, activeText: Confrimedstring, recovered: recoveredstring , Province: stats.province)
                displaypopView()
                
            }
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UILabel()
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 0.5
        label.layer.shadowOpacity = 0.3
        label.layer.cornerRadius = 10
        if index == 0 {
            label.text = "Get updates Every 24Hours"
            label.font = font
        }else{
            label.text = "Information for every State"
            label.font = font
        }
        
        return label
    }
    
    
}


