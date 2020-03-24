//
//  CountryCell.swift
//  TRACKCOVID-19
//
//  Created by Ebuka Egbunam on 3/22/20.
//  Copyright © 2020 Ebuka Egbunam. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    var CountryImage = UIImageView()
    var CountryName = UILabel()
    var circleBorder = CALayer()
    var SecondcircleBorder = CALayer()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = .black
        CountryName.textColor = .black
        
        addSubview(CountryImage)
        addSubview(CountryName)
        
        configureImageView()
        configurelabel()
        setImageContraints()
        setLabelContraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCountryName(covidstats : response){
        CountryName.text = covidstats.country
    }
    
    func setcountryImage(covidstats : response){
        var name = covidstats.country
        if name == "USA"{
            name = "United States"
        }
        
      
        if let iso = IsoCountryCodes.searchByName(name){
            let imagename = iso.alpha2.lowercased() + ".png"
            let image = UIImage(named: imagename)
            CountryImage.image = image
        }else{
            //no image
            //fatalError()
        }
    }
    
    private func configureImageView(){
        let globalheight = contentView.frame.height
        let globalwidth = contentView.frame.width
        print(globalwidth)
        let height :CGFloat = 80
        print(globalheight)
        let size = CGSize(width: 90, height: 90)
        let point = CGPoint(x: 25, y: 5)
        CountryImage.frame = CGRect(origin: point, size: size)
        CountryImage.clipsToBounds = true
        CountryImage.layer.cornerRadius = 1/2
            * CountryImage.frame.width
        CountryImage.backgroundColor = .gray
        CountryImage.alpha = 0.9
        CountryImage.contentMode = .scaleAspectFill
        
    }
    
    
     private func configurelabel(){
        let globalwidth = contentView.frame.width
        let size = CGSize(width: 110, height: 50)
        let point = CGPoint(x: 70 + globalwidth/2.5, y: 10)
        CountryName.frame = CGRect(origin: point, size: size)
        CountryName.clipsToBounds = true
        CountryName.numberOfLines = 0
        CountryName.adjustsFontSizeToFitWidth = true
        CountryName.backgroundColor = UIColor.init(hex: Constants.lightblue)
        CountryName.layer.cornerRadius = 10
        CountryName.textAlignment = .center
        CountryName.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name: "ArialRoundedMTBold"]), size: 16)
        
    }
    
    
     private func setImageContraints(){
        CountryImage.translatesAutoresizingMaskIntoConstraints = true
        CountryImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       CountryImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        CountryImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        CountryImage.widthAnchor.constraint(equalTo: CountryImage.heightAnchor, multiplier: 16/9).isActive = true
    }

    private func setLabelContraints(){
        CountryName.translatesAutoresizingMaskIntoConstraints = true
       CountryName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        CountryName.leadingAnchor.constraint(equalTo: CountryImage.trailingAnchor, constant: 20).isActive = true
        CountryName.heightAnchor.constraint(equalToConstant: 80).isActive = true
        CountryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true

    }
    
    
    private func drawCircle(onImageView imageView: UIImageView , withColor color : CGColor , andTagToRemove _tag: Int, withlayer _layer : CALayer ) {
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = 3.0
        circleBorder.borderColor = color
        circleBorder.bounds = imageView.bounds
        circleBorder.position = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)
    

    }
    private func drawSecondCircle(onImageView imageView: UIImageView , withColor color : CGColor , andTagToRemove _tag: Int, withlayer _layer : CALayer ) {
      //this function is fragile and not stable
        
        
        SecondcircleBorder.backgroundColor = UIColor.clear.cgColor
        SecondcircleBorder.borderWidth = 6.0
        SecondcircleBorder.borderColor = color
        SecondcircleBorder.bounds = layer.bounds
        SecondcircleBorder.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        SecondcircleBorder.cornerRadius = layer.frame.size.width / 2
        layer.insertSublayer(SecondcircleBorder, at: 0)
    

    }
}
