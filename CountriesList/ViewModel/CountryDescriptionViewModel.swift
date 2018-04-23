//
//  CountryDescriptionViewModel.swift
//  CountriesList
//
//  Created by Imal on 19.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

protocol CountryDescriptionViewModelType {
    var allCountries : [Country]! { get set }
    var selectedCountryIndex : Int! { get set }
}

class CountryDescriptionViewModel: CountryDescriptionViewModelType {
    var allCountries: [Country]!
    var selectedCountryIndex : Int!
    
    convenience init(allCountries : [Country],
                     selectedCountryIndex : Int) {
        self.init()
        self.allCountries = allCountries
        self.selectedCountryIndex = selectedCountryIndex
    }
}
