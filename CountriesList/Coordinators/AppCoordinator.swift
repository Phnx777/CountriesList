//
//  AppCoordinator.swift
//  CountriesList
//
//  Created by Imal on 18.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    func start() {
        let coordinator = CountryCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
