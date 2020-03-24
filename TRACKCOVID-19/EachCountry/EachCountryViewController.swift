//
//  EachCountryViewController.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/23/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit



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
    
    
    let font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
    
    override func viewDidLoad() {
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
        let color = UIColor.init(hex: Constants.errieBlack)?.withAlphaComponent(0.8)
        view.backgroundColor = color
            
            //UIColor.init(hex: Constants.lightblue)?.withAlphaComponent(0.8)
        setupdeathView()
        setuprecoveryView()
        setupActiveView()
        setupCountryImage()
        setuptottalView()
        setupTopView()
    }
    
    func setupdeathView(){
        guard let countryInformation = countryInformation else {return}
        
        let deathToll = countryInformation.deaths.total
        let image = UIImage(named: "death.png")
        deathsImage.image = image
        deathsImage.contentMode = .scaleAspectFit
        deathsLabel.text = "Death: \(deathToll)"
        deathsLabel.font = font
        
    }
    
    
    func setuprecoveryView(){
        let recovery = countryInformation?.cases.recovered
        let image = UIImage(named: "recovery.png")
        recoveredImage.image = image
        recoveredImage.contentMode = .scaleAspectFit
        recoveredLabel.font = font
        recoveredLabel.text = "Recovered: \(recovery ?? 0)"
        
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
        activeCasesLabel.numberOfLines = 0
        activeCasesLabel.clipsToBounds = true
    }
    
    func setupCountryImage(){
        
        let cName = countryInformation?.country
        
        countryFlagImage.image = UIImage(named: setcountryImage(name: (cName ?? "")))
        countryFlagImage.layer.cornerRadius = 10
    }
    
    
    func setuptottalView(){
        
        let total = countryInformation?.cases.total
        totalCasesLabel.text = "Total Infected: \(total ?? 0)"
        totalCasesLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 20)
        totalCasesLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    
    func setupTopView(){
        topView.backgroundColor = UIColor.init(hex: Constants.lightblue)?.withAlphaComponent(0.8)
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 10
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
