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
    
    var flower : Flower!
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureHeader()
    }
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    var headerView : UIView?
}

// MARK: - Lifecycle
extension SightingTableViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.48) {
            self.headerView?.alpha = 1.0
        }
    }
}

// MARK: Datasource
extension SightingTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flower.sightings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SightingCell", for: indexPath) as? SightingCell {
            let sighting = flower.sightings[indexPath.row]
            cell.personLabel.text = sighting.person != nil ? sighting.person : ""
            cell.foundLabel.text = sighting.sighted != nil ? sighting.sighted : ""
            if let location = sighting.location {
                cell.locationLabel.text = "Location: \t\(location)"
            }

            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: Helpers
extension SightingTableViewController {
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backButtonHandler(_:)))
    }
    
    fileprivate func configureHeader() {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderSightingCell") as? HeaderSightingCell {
            if let genus = flower.genus, let species = flower.species {
                cell.latinLabel.text = "Genus: \(genus)\nSpecies: \(species)"
            }

            let sighting = flower.sightings
            cell.sightingCountLabel.text = "Amount of sightings: \(sighting.count)"
            
            self.headerView = cell.contentView
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            if let headerView = headerView {
                blurredEffectView.frame = headerView.frame
                headerView.frame.origin.y = (236-headerView.frame.height)
                headerView.addSubview(blurredEffectView)
                headerView.sendSubview(toBack: blurredEffectView)
                headerView.alpha = 0.0
                self.view.addSubview(headerView)
            }
        }
    }
}

// MARK: Actions
extension SightingTableViewController {
    
    @objc func backButtonHandler(_ sender: AnyObject) {
        // buttonAnimation
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
