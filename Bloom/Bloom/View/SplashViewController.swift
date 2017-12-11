//
//  SplashViewController.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/11/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateFlower()
    }
    
    func animateFlower() {
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.48, animations: {
            self.flowerImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        }) { (end) in
            UIView.setAnimationCurve(.easeInOut)
            UIView.animate(withDuration: 0.24, animations: {
                self.flowerImageView.transform = CGAffineTransform.identity
            }, completion: { (end2) in
                UIView.setAnimationCurve(.linear)
                UIView.animate(withDuration: 0.48, animations: {
                    self.flowerImageView.transform = CGAffineTransform(rotationAngle: -1 * (180.0*CGFloat.pi*0.999)/180.0)
                    self.flowerImageView.alpha = 0.0
                }, completion: { (end3) in
                    self.performSegue(withIdentifier: "splashSegue", sender: self)
                })
            })
        }
    }
}
