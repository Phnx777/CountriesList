//
//  Coordinator.swift
//  ObserveCountry
//
//  Created by Imal on 17.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class Coordinator {
    var childCoordinators = [Coordinator]()
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
