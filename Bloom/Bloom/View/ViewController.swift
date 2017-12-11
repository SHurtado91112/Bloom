//
//  ViewController.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/7/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import expanding_collection

class ViewController: ExpandingViewController {
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate var flowers: [Flower] = []
    fileprivate var cache : NSCache<AnyObject, AnyObject>?
    
    @IBOutlet weak var pageLabel : UILabel!
    
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
        self.view.alpha = 0.0
        
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
            self.view.alpha = 1.0
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        guard let titleView = navigationItem.titleView else { return }
//        let center = UIScreen.main.bounds.midX
//        let diff = center - titleView.frame.midX
//        titleImageViewXConstraint.constant = diff
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

// MARK: Helpers
extension ViewController {
    
    fileprivate func loadData() {
        //load flower data
        BloomAPI().getFlowerData(success: { (data) in
            print(data)
            if let dictArr = data as? [Dictionary<String,Any>]
            {
                for dict in dictArr {
                    self.flowers.append(Flower(dict: dict))
                }
                print(self.flowers.count)
                
                DispatchQueue.main.async {
                    self.fillCellIsOpenArray()
                    self.collectionView?.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
    
//    fileprivate func getViewController() -> ExpandingTableViewController {
//        let storyboard = UIStoryboard(storyboard: .Main)
//        let toViewController: DemoTableViewController = storyboard.instantiateViewController()
//        return toViewController
//    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
}

/// MARK: Gesture
extension ViewController {
    
    fileprivate func addGesture(to view: UIView) {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeHandler(_:)))
        upGesture.direction = .up
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeHandler(_:)))
        downGesture.direction = .down
        
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? BaseCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
//            pushToViewController(getViewController())
            
//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
    
}

// MARK: UIScrollViewDelegate
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageLabel.text = "\(currentIndex+1)/\(flowers.count)"
    }
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
//                    if let items = dict["items"] as? NSArray, let first = items[0] as? NSDictionary {
//                        if let link = first["link"] as? String, let url = URL(string: link) {
//                            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                                cell.backgroundImageView.image = image
//                                cache.setObject(image, forKey: (indexPath as NSIndexPath).row as AnyObject)
//                            }
//                        }
//                    }
//
//                }, failure: { (error) in
//                    print(error.localizedDescription)
//                })
//            }
//        }
//
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
//            pushToViewController(getViewController())
            
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
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BaseCell.self), for: indexPath)
    }
}
