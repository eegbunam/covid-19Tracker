//
//  EachCountryViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/23/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit
import BetterSegmentedControl


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
    
    override func viewDidLoad() {
        
        DataService.sharedClient.testEndPointCountry(Country: countryInformation?.country ?? "") { [weak self](data) in
            if let data = data{
                let stats = data.stat_by_country
                self?.dataList = stats
                self?.tableViewList = self!.dataList
                stat_by_country.removeDuplicateDates(data: self!.dataList)
                DispatchQueue.main.async {
                    self?.lastUpdateTableView.reloadData()
                }
            }else{
                print("data is nil")
            }
            
        }
        
        DataService.sharedClient.getStateData(country: countryInformation?.country ?? "") {[weak self] (covid) in
            if let covid = covid{
                
                if covid.message == "OK"{
                    let data = covid.data.covid19Stats
                    self?.stateList = data
                }
               
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
        setuppopView()
        
    }
    
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
    
    func setuppopView(){
        let width = view.frame.width - 150
        let height = view.frame.height - 550
        let x = (view.frame.width - width)/2
        let y = view.frame.height
        originalPopUpY = y
        popView.frame = CGRect(x: x, y: y, width: width, height: height)
        popView.layer.cornerRadius = 10
        popView.backgroundColor = darkBlue
        popView.layer.cornerRadius = 10
        view.addSubview(popView)
        
        let button = UIButton(frame: CGRect(x: popView.frame.width - 30, y: 0, width: 30, height: 30))
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handlepopcancelButton), for: .touchUpInside)
        button.setImage(UIImage(named: "cancel.png"), for: .normal)
        popView.addSubview(button)
        
        let activeLabel = UILabel()
        activeLabel.frame = CGRect(x: 20, y: 40, width: width - 35, height: 50)
        activeLabel.backgroundColor = .white
        activeLabel.font = font
        activeLabel.text  = "This is the activeLabel"
        //activeLabel.layer.cornerRadius = 20
        popView.addSubview(activeLabel)
            
        
        let deathLabel = UILabel()
        deathLabel.frame = CGRect(x: 20, y: 105, width: width - 35 , height: 50)
        deathLabel.backgroundColor = .white
        deathLabel.font = font
        deathLabel.text = "The is the deathLabel"
        deathLabel.layer.cornerRadius = 10
        popView.addSubview(deathLabel)
        
        let recoveredLabel = UILabel()
        recoveredLabel.frame = CGRect(x: 20, y: 170, width: width - 35 , height: 50)
        recoveredLabel.backgroundColor = .white
        recoveredLabel.font = font
        recoveredLabel.text = "The is recovered Label"
        recoveredLabel.layer.cornerRadius = 10
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
            segments: LabelSegment.segments(withTitles: ["Latest Update", "States"],
                                            normalFont:font,
                                            normalTextColor: darkBlue,
                                            selectedFont:font,
                                            selectedTextColor: .white),
            index: 0,
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
    
    
    @objc func segmentedControlFuntion(_ sender : BetterSegmentedControl){
        if sender.index == 0{
            tableViewList = dataList
            index = 0
        }
        else{
            index = 1
            print("index is 1")
            tableViewList = stateList
            
        }
        lastUpdateTableView.reloadData()
        
    }
    
    
    func setupTopView(){
        //topView.backgroundColor = UIColor.init(hex: Constants.lightblue)?.withAlphaComponent(0.8)
        topView.clipsToBounds = true
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
                cell.textLabel?.text = finalList[indexPath.row].province
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displaypopView()
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
