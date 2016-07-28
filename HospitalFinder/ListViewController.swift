//
//  listViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ListViewController: UITableViewController,UISearchResultsUpdating {
    
    var hospitals = [Hospital]()
    var toPass: String?
    var filterModel = FilterModel()
    var textfilteredHospitals = [Hospital]()
    var filteredHospitals = [Hospital]()
    let searchController = UISearchController(searchResultsController: nil)
    var locationManager:LocationManager?
    var userLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor(red:0.13, green:0.17, blue:0.24, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.locationManager = LocationManager()
        do{
            try
                self.locationManager!.getlocationForUser { (userLocation: CLLocation) -> () in
                    print(userLocation)
                    self.userLocation = userLocation
                    self.getAllHospitals()
            }
        }catch {
            self.getAllHospitals()
        }
        print(toPass!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        self.searchController.searchBar.backgroundColor = UIColor.whiteColor()
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        let tbvc = self.tabBarController as! MainTabController
        filterModel = tbvc.filterModel
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        print(filterModel.distance)
        print(filterModel.rating)
        filteredHospitals = applyFilterModel(self.filterModel, hospitals: hospitals)
        
        tableView.reloadData()
        
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        let hospital:Hospital
        
        // check for active search
        if searchController.active && searchController.searchBar.text != "" {
            hospital = textfilteredHospitals[indexPath.row]
        } else {
            hospital = filteredHospitals[indexPath.row]
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
            return textfilteredHospitals.count
        }
        return filteredHospitals.count
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
                        newHospital.rating = (result.valueForKey("rating") as? Float)!
                        newHospital.imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String)
                        // do not add image if image URL does not exist
                        if let imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String) {
                            newHospital.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
                            
                            
                            
                        }
                        
                        if self.userLocation != nil{
                            
                            let tempLat = result.valueForKey("latitude") as! Double
                            let tempLong = result.valueForKey("longitude") as! Double
                            let tempLocation = CLLocation(latitude: tempLat, longitude: tempLong)
                            newHospital.distanceFromUser = (self.userLocation?.distanceFromLocation(tempLocation))!/1000 * 0.621371
                        }
                        
                        self.hospitals.append(newHospital)
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.filteredHospitals = self.applyFilterModel(self.filterModel, hospitals: self.hospitals)
                        
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        textfilteredHospitals = filteredHospitals.filter { hospital in
            return hospital.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    func applyFilterModel(model:FilterModel,hospitals:[Hospital]) -> [Hospital]{
        
        var outHospitals = [Hospital]()
        
        outHospitals = hospitals.filter { hospital in
            return hospital.rating > model.rating && (hospital.distanceFromUser as Double) < model.distance
        }
        
        return outHospitals
        
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