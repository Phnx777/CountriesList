//
//  Country.swift
//  ObserveCountry
//
//  Created by Imal on 17.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import EVReflection
class Country: EVObject {
    var name : String?
    var population : Int = 0
    var capital : String?
    var alpha3Code : String?
    var borders : [String]?
    var currencies : [Currency]?
}
