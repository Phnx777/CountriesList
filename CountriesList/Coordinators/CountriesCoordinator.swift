//
//  CountryCoordinator.swift
//  CountriesList
//
//  Created by Imal on 18.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

protocol CountryCoordinatorDelegate: class {
    func countryCoordinatorDidFinish(countryCoordinator: CountryCoordinator)
}

final class CountryCoordinator: Coordinator {
    func start() {
        let viewModel = CountriesViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = CountriesViewController()
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

extension CountryCoordinator : CountriesViewModelCoordinatorDelegate {
    
    func countriesViewModelDidSelectData(viewModel: CountriesViewModel,
                                         allCountries: [Country],
                                         selectedCountryIndex : Int) {
        let countryDescriptionCoordinator = CountryDescriptionCoordinator(navigationController: navigationController,
                                                                          allCountries: allCountries,
                                                                          selectedCountryIndex : selectedCountryIndex)
        countryDescriptionCoordinator.delegate = self
        countryDescriptionCoordinator.start()
        childCoordinators.append(countryDescriptionCoordinator)
    }
}

extension CountryCoordinator : CountryDescriptionCoordinatorDelegate {
    
    func countryDescriptionCoordinatorDidFinish(coordinator: CountryDescriptionCoordinator) {
        if childCoordinators.count > 0 {
            childCoordinators.removeLast()
        }
    }
    
}
