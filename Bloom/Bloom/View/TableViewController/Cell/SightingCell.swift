//
//  SightingCell.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/12/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

class SightingCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

