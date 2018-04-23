//
//  CountryDescriptionViewController.swift
//  CountriesList
//
//  Created by Имал Фарук on 20.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

protocol CountryDescriptionViewControllerDelegate : class {
    func backButtonPressed()
}

class CountryDescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var viewModel : CountryDescriptionViewModel!
    weak var delegate : CountryDescriptionViewControllerDelegate?
    
    convenience init(viewModel : CountryDescriptionViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country's description"
        configure(index: viewModel.selectedCountryIndex,
                  countries: viewModel.allCountries)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController {
            delegate?.backButtonPressed()
        }
    }
    
    func configure(index : Int, countries: [Country]) {
        if countries.indices.contains(index) {
            let country = countries[index]
            let nameString = "Name: \(country.name ?? "")\n"
            let capitalString = "Capital: \(country.capital ?? "")\n"
            let populationString = "Population: \(country.population)\n"
            
            let borders = countries.compactMap { enumeratedCountry -> (Country?) in
                if let alpha3Code = enumeratedCountry.alpha3Code,
                    country.borders != nil,
                    (country.borders?.contains(alpha3Code))! {
                    return enumeratedCountry
                }
                return nil
            }.compactMap { $0.name }.joined(separator: ", ")
            
            let bordersString = "Borders: " + borders + "\n"
            let currency = country.currencies?.compactMap({$0.name}).joined(separator: ", ")
            let currenciesString = "Currency: " + (currency ?? "") + "\n"
            let fullString = nameString + capitalString + populationString +
                bordersString + currenciesString
            descriptionLabel.text = fullString
        }
    }
    
}

