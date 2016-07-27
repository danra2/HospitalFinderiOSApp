//
//  listViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController,UISearchResultsUpdating {
    
    var hospitals = [Hospital]()
    var toPass: String?
    var filterModel = FilterModel()
    var filteredHospitals = [Hospital]()
    let searchController = UISearchController(searchResultsController: nil)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        print(toPass!)
        
        getAllHospitals()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let tbvc = self.tabBarController as! MainTabController
        filterModel = tbvc.filterModel
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        print(filterModel.distance)
       
      
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        let hospital:Hospital
        
        // check for active search
        if searchController.active && searchController.searchBar.text != "" {
            hospital = filteredHospitals[indexPath.row]
        } else {
            hospital = hospitals[indexPath.row]
        }
        
        
        if let myImage = hospital.image{
            cell.hospitialImageView.image = myImage
        }
        
        
        cell.nameLabel.text = "\(hospital.name)"
        cell.locationLabel.text = "\(hospital.location)"
        cell.phoneButtonLabel.setTitle(hospital.phoneNumber, forState: .Normal)
        cell.websiteButton.setTitle(hospital.website, forState: .Normal)
        cell.ratingLabel.text = "Rating: \(hospital.rating)"

        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredHospitals.count
        }
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
                    for result in jsonResult{
                        // need to put this code into a convience initalizier
                        let newHospital = Hospital()
                        newHospital.name = "\(result.valueForKey("name")!)"
                        //newHospital.name = "\(result.valueForKey("name")!)"
                        newHospital.location = "\(result.valueForKey("location")!)"
                        newHospital.phoneNumber = (result.valueForKey("phone") as? String)!
                        newHospital.rating = (result.valueForKey("rating") as? Double)!
                        newHospital.imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String) 
                        // do not add image if image URL does not exist
                        if let imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String) {
                            newHospital.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
                            
                        }
                   
                        self.hospitals.append(newHospital)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredHospitals = hospitals.filter { hospital in
            return hospital.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
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