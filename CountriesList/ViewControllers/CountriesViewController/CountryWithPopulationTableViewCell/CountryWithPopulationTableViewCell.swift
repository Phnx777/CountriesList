//
//  CountryWithPopulationTableViewCell.swift
//  CountriesList
//
//  Created by Imal on 18.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class CountryWithPopulationTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
