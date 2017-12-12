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
    @IBOutlet weak var swipeImageView: UIImageView!
    
    @IBOutlet weak var genusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
        
        swipeImageView.image = UIImage(named: "swipe_up")?.withRenderingMode(.alwaysTemplate)
    }
    
    func changeSwipeImage(open: Bool)
    {
        if open {
            swipeImageView.image = UIImage(named: "swipe_down")?.withRenderingMode(.alwaysTemplate)
        }
        else {
            swipeImageView.image = UIImage(named: "swipe_up")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
