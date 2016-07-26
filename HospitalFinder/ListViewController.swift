//
//  listViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var hospitals = []
    var toPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(toPass!)
        getAllHospitals()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        
        // do not add image if image URL does not exist
        if let imageUrl = hospitals[indexPath.row].valueForKey("images")?.firstObject??.valueForKey("url")! as? String {
            let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
            cell.hospitialImageView.image = myImage
        }
        
        cell.nameLabel.text = "\(hospitals[indexPath.row].valueForKey("name")!)"
        cell.locationLabel.text = "\(hospitals[indexPath.row].valueForKey("location")!)"
        cell.phoneButtonLabel.setTitle(hospitals[indexPath.row].valueForKey("phone")! as? String, forState: .Normal)
        cell.websiteButton.setTitle(hospitals[indexPath.row].valueForKey("website")! as? String, forState: .Normal)
        cell.ratingLabel.text = "Rating: \(hospitals[indexPath.row].valueForKey("rating")!)"

        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    
    func getAllHospitals() {
        print("> getAllHospitals()")
        Hospital.getAllHospitals() {
            data, response, error in
            do {

                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
//                    print(jsonResult.firstObject)
                    
                    self.hospitals = jsonResult
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        let urlFromButton = sender.currentTitle!
        UIApplication.sharedApplication().openURL(NSURL(string: urlFromButton)!)
        
    }
    @IBAction func phoneButtonPressed(sender: UIButton) {
        let numberFromButton = sender.currentTitle!
        UIApplication.sharedApplication().openURL(NSURL(string: numberFromButton)!)
    }
    
}