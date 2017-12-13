//
//  SightingManageTableViewController.swift
//  Bloom
//
//  Created by Steven Hurtado on 12/13/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

protocol SightingManageDelegate {
    func insertFlowerList(data: Dictionary<String, Any>)
    func updateFlowerList(data: Dictionary<String, Any>, index: Int)
}

class SightingManageTableViewController: UITableViewController {

    @IBOutlet weak var personField : UITextField!
    @IBOutlet weak var locationField : UITextField!
    @IBOutlet weak var dateField : UIDatePicker!
    
    var delegate : SightingManageDelegate!
    var oldSighting : Sighting!
    
    var flowerName : String!
    var index : Int = -1
    var isUpdate : Bool = false
    var loader = UIImageView()
    var stopLoading = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Sighting Information"
        
        //nav set up
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sendData))
        tableView.backgroundColor = UIColor(displayP3Red: 198.0/255.0, green: 196.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        
        tableView.reloadData()
        
        //set up for update
        if(isUpdate) {
            if let person = oldSighting.person, let location = oldSighting.location {
                personField.text = person
                locationField.text = location
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/d/yyyy"
                if let dateStr = oldSighting.sighted, let date = dateFormatter.date(from: dateStr) {
                    dateField.date = date
                }
            }
        }
        
        loader = UIImageView(frame: CGRect(x: self.view.frame.width/2-30, y:  self.view.frame.height/2-120, width: 60, height: 60))
        loader.image = UIImage(named: "flower-default")
        loader.alpha = 0.0
        self.view.addSubview(loader)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func sendData() {
        self.loadLoader()
        if(isUpdate) {
            let sightingDate = dateField.date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M/d/yyyy"
            let sighting = dateFormat.string(from: sightingDate)
            
            if let person = personField.text, let location = locationField.text, let name = flowerName {
                if person.count > 8 {
                    errorMessage()
                    return
                }
                guard let oldSighted = oldSighting.sighted, let oldLoc = oldSighting.location, let oldPerson = oldSighting.person else{return}
                let pass = "{\"NAME\":\"\(name)\", \"PERSON\":\"\(person)\", \"LOCATION\":\"\(location)\",\"SIGHTED\":\"\(sighting)\",\"OLDSIGHTED\":\"\(oldSighted)\",\"OLDNAME\":\"\(name)\",\"OLDLOCATION\":\"\(oldLoc)\",\"OLDPERSON\":\"\(oldPerson)\"}"
                let passDict : Dictionary<String, Any> = ["NAME" : flowerName, "PERSON" : person, "LOCATION" : location, "SIGHTED" : sighting]
                print(pass)
                BloomAPI().updateSightingData(json: pass, success: { (data) in
                    
                    DispatchQueue.main.async {
                        self.stopLoader()
                        self.dismiss(animated: true) {
                            self.delegate.updateFlowerList(data: passDict, index: self.index)
                        }
                    }
                    
                    print("Successful update")
                    
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        self.stopLoader()
                        self.dismiss(animated: true, completion: nil)
                    }
                    print(error.localizedDescription)
                    
                })
            }
        }
        else {
            
            let sightingDate = dateField.date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M/d/yyyy"
            let sighting = dateFormat.string(from: sightingDate)
            
            if let person = personField.text, let location = locationField.text, let name = flowerName {
                if person.count > 8 {
                    errorMessage()
                    return
                }
                let pass = "{\"NAME\":\"\(name)\", \"PERSON\":\"\(person)\", \"LOCATION\":\"\(location)\",\"SIGHTED\":\"\(sighting)\"}"
                let passDict : Dictionary<String, Any> = ["NAME" : flowerName, "PERSON" : person, "LOCATION" : location, "SIGHTED" : sighting]
                print(pass)
                BloomAPI().insertSightingData(json: pass, success: { (data) in
                    
                    DispatchQueue.main.async {
                        self.stopLoader()
                        self.dismiss(animated: true) {
                            self.delegate.insertFlowerList(data: passDict)
                        }
                    }
                    
                    print("Successful insertion")
                    
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        self.stopLoader()
                        self.dismiss(animated: true, completion: nil)
                    }
                    print(error.localizedDescription)
                    
                })
            }
            
        }
    }
    
    func errorMessage() {
        let alertController = UIAlertController(title: "Wait!", message: "Make sure the name is only 8 characters max.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @objc func closeSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 60.0))
        header.backgroundColor = UIColor(displayP3Red: 198.0/255.0, green: 196.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        
        let titleLabel = UILabel(frame: CGRect(x: 8.0, y: 0.0, width: header.frame.width, height: header.frame.height))
        titleLabel.textColor = UIColor.white
        titleLabel.text = isUpdate ? "Update Sighting" : "Add New Sighting"
        
        header.addSubview(titleLabel)
        
        return header
    }

//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: CAANIMATION DELEGATE
extension SightingManageTableViewController: CAAnimationDelegate {
    fileprivate func loadLoader() {
        UIView.animate(withDuration: 0.48) {
            self.loader.alpha = 1.0
        }
        
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
        UIView.animate(withDuration: 0.48) {
            self.loader.alpha = 0.0
        }
        stopLoading.invalidate()
    }
}
