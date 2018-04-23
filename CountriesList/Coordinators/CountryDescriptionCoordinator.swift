//
//  CountryDescriptionCoordinator.swift
//  CountriesList
//
//  Created by Imal on 19.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

protocol CountryDescriptionCoordinatorDelegate: class {
    func countryDescriptionCoordinatorDidFinish(coordinator: CountryDescriptionCoordinator)
}

class CountryDescriptionCoordinator: Coordinator {
    
    weak var delegate: CountryDescriptionCoordinatorDelegate?
    var viewModel : CountryDescriptionViewModel!
    
    init(navigationController: UINavigationController?,
         allCountries : [Country],
         selectedCountryIndex : Int) {
        super.init(navigationController: navigationController)
        
        viewModel = CountryDescriptionViewModel(allCountries: allCountries,
                                                selectedCountryIndex: selectedCountryIndex)
    }
    
    func start() {
        let viewController = CountryDescriptionViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

extension CountryDescriptionCoordinator : CountryDescriptionViewControllerDelegate {
    
    func backButtonPressed() {
        delegate?.countryDescriptionCoordinatorDidFinish(coordinator: self)
    }
    
}
