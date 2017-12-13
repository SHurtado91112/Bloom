//
//  BaseCell.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/7/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

class BaseCell: BasePageCollectionCell {
    
    //base data data for front
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var latinLabel: UILabel!
    @IBOutlet weak var sightingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        latinLabel.text = "Getting Information..."
        sightingLabel.text = "Please Wait."
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
}
