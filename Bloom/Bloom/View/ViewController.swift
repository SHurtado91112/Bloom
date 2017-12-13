//
//  ViewController.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/7/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import expanding_collection
import QuartzCore

class ViewController: ExpandingViewController {
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate var flowers: [Flower] = []
    fileprivate var cache : NSCache<AnyObject, AnyObject>?
    var stopLoading = Timer()
    
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageLabel : UILabel!
    
    @IBOutlet weak var loader: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Lifecycle 🌎
extension ViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 335)
        super.viewDidLoad()
        self.collectionView?.alpha = 0.0
        self.title = "Bloom"
        
        //set up gradient
        gradient()
        
        //load data and fill data source
        loadData()
        
        //add other features and register cell
        registerCell()
        addGesture(to: collectionView!)
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.48) {
            self.collectionView?.alpha = 1.0
        }
        
        pageLabel.text = "\(currentIndex+1)/\(flowers.count)"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff
    }
    
    func gradient() {
        let gradientColors: [CGColor] = [UIColor.myOffWhite.cgColor, UIColor.myTimberWolf.cgColor]
        let gradientLocations: [Float] = [0.35, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//extension ViewController: FlowerDelegate {
//    func itemsDownloaded(items: [Dictionary]) {
//
//        for dict in items {
//            flowers.append(Flower(dict: dict))
//        }
//
//
//    }
//
//}

// MARK: CAANIMATION DELEGATE
extension ViewController: CAAnimationDelegate {
    fileprivate func loadLoader() {
        stopLoading = Timer.scheduledTimer(timeInterval: 0.98, target: self, selector: #selector(keepLoading), userInfo: nil, repeats: true)
        stopLoading.fire()
    }
    
    @objc func keepLoading() {
        
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.delegate = self
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * -2))
        fullRotation.duration = 0.96
        fullRotation.repeatCount = 1
        self.loader.layer.add(fullRotation, forKey: "360")
    }
    
    fileprivate func stopLoader() {
        stopLoading.invalidate()
    }
}

// MARK: Helpers
extension ViewController {
    
    fileprivate func loadData() {
        loadLoader()
        
        //load flower data
//        BloomAPI().getFlowerData(success: { (data) in
//            self.stopLoader()
//            if let dictArr = data as? [Dictionary<String,Any>]
//            {
//                for dict in dictArr {
//                    self.flowers.append(Flower(dict: dict))
//                }
//
//                DispatchQueue.main.async {
//                    self.fillCellIsOpenArray()
//                    self.collectionView?.reloadData()
//                    self.pageLabel.text = "\(self.currentIndex+1)/\(self.flowers.count)"
//                }
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
        //load sighting data
        
        //load feature data
        
        cache = NSCache()
    }
    
    
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: BaseCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: BaseCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: flowers.count)
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let toViewController = storyboard.instantiateViewController(withIdentifier: "SightingTVC") as? SightingTableViewController else {return ExpandingTableViewController()}
        
        if let name = flowers[currentIndex].comName {
            toViewController.title = name
            toViewController.flower = flowers[currentIndex]
        }
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        guard let superView = navigationItem.titleView?.superview else {return}
        guard let first = navigationItem.titleView else {return}
        titleImageViewXConstraint = NSLayoutConstraint(item: first, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        navigationItem.titleView?.addConstraint(titleImageViewXConstraint)
    }
    
}

/// MARK: Gesture
extension ViewController {
    
    fileprivate func addGesture(to view: UIView) {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeHandler(_:)))
        upGesture.direction = .up
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeHandler(_:)))
        downGesture.direction = .down
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.backOpened))
        
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? BaseCell else { return }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        
        cellsIsOpen[indexPath.row] = cell.isOpened
        
        if sender.direction == .up {
            let flower = flowers[indexPath.row]
            if let name = flower.comName, let genus = flower.genus, let species = flower.species {
                if flower.sightings.count > 0 {
                    return
                }
                
                BloomAPI().getSightingData(flowerName: name, success: { (data) in
                    print(data)
                    if let dictArr = data as? [Dictionary<String,Any>]
                    {
                        for dict in dictArr {
                            let sighting = Sighting(dict: dict)
                            flower.sightings.append(sighting)
                        }
                        
                        DispatchQueue.main.async {
                            cell.latinLabel.text = "Genus: \(genus)\nSpecies: \(species)"
                            
                            let sighting = flower.sightings
                            cell.sightingLabel.text = "Sightings from \(sighting.count) friends:\n\n"
                            
                            var i = 0
                            var append = ""
                            while sighting.count > 0 && (i < sighting.count && i < 3) {
                                if let person = sighting[i].person {
                                    append += "\(person), "
                                }
                                i += 1
                            }
                            append += "etc..."
                            if let orig = cell.sightingLabel.text  {
                                cell.sightingLabel.text = orig + append
                            }
                        }
                    }
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    @objc func backOpened() {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? BaseCell else { return }
        if cell.isOpened == true {
            pushToViewController(getViewController())//, cell: cell)
            
            //            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
            //                rightButton.animationSelected(true)
            //            }
        }
    }
    
}

// MARK: UIScrollViewDelegate
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageLabel.text = "\(currentIndex+1)/\(flowers.count)"
    }
    
//    func pushToViewController(_ viewController: ExpandingTableViewController, cell: BaseCell) {
//        super.pushToViewController(viewController)
//    }
}

// MARK: UICollectionViewDataSource
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? BaseCell else { return }
        
        let index = indexPath.row % flowers.count
        let flower = flowers[indexPath.row]
        
//        guard let cache = self.cache else{return}
//        if (cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
//            // Use cache
//            print("Cached image used, no need to download it")
//            cell.backgroundImageView.image = cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
//        } else {
//            DispatchQueue.main.async {
//                print("dispatch")
//                BloomAPI().imageSearch(query: flower.comName, success: { (dict) in
//                    print("FROM CLOSURE")
//                    guard let dict = dict as? Dictionary<String,Any> else{return}
//                    if let items = dict["items"] as? NSArray, let first = items[0] as? NSDictionary {
//                        if let link = first["link"] as? String, let url = URL(string: link) {
//                            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                                cell.backgroundImageView.image = image
//                                cache.setObject(image, forKey: (indexPath as NSIndexPath).row as AnyObject)
//                                //change imageview aspect to fill if found
//                            }
//                        }
//                    }
//
//                }, failure: { (error) in
//                    print(error.localizedDescription)
//                })
//            }
//        }

        if let name = flower.comName {
            cell.customTitle.text = name
        }
        
        print(index)
        print(self.flowers.count)
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCell
            , currentIndex == indexPath.row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())
            
//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flowers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BaseCell.self), for: indexPath) as? BaseCell else {return UICollectionViewCell()}
        return cell
    }
}
