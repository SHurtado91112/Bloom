//
//  SightingTableViewController.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/12/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

class SightingTableViewController: ExpandingTableViewController {
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    
}

// MARK: - Lifecycle
extension SightingTableViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
}

// MARK: Helpers
extension SightingTableViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonHandler(_:)))
    }   
}

// MARK: Actions
extension SightingTableViewController {
    
    @objc func backButtonHandler(_ sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [ViewController?] = navigationController?.viewControllers.map { $0 as? ViewController } ?? []
        
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate
extension SightingTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    if scrollView.contentOffset.y < -25 {
        //      // buttonAnimation
        //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        //
        //      for viewController in viewControllers {
        //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //          rightButton.animationSelected(false)
        //        }
        //      }
        //      popTransitionAnimation()
        //    }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
}
