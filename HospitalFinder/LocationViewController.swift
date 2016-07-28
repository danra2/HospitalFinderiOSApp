//
//  locationViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var hoursTitleLabel: UILabel!
    
    @IBOutlet weak var hoursDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var hospitals = [Hospital]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllHospitals()
        fullScreenMap()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.mapView.delegate = self
        
        
    }
    func fullScreenMap() {
        hoursTitleLabel.hidden = true
        hoursDescriptionLabel.hidden = true
        descriptionTitleLabel.hidden = true
        descriptionLabel.hidden = true
        nameLabel.hidden = true
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        
        let widthConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: width)
        self.view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height)
        self.view.addConstraint(heightConstraint)
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
        zoomToRegion((view.annotation?.coordinate.latitude)!, long: (view.annotation?.coordinate.longitude)!)
        
        print(view.annotation?.coordinate)
        print(view.annotation?.title)
        
        nameLabel.text = (view.annotation?.title)!
        print(hospitals)
        hoursTitleLabel.hidden = false
        hoursDescriptionLabel.hidden = false
        descriptionTitleLabel.hidden = false
        descriptionLabel.hidden = false
        nameLabel.hidden = false
        
        let height = UIScreen.mainScreen().bounds.height/1.7
        let heightConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height)
        self.view.addConstraint(heightConstraint)
    }
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        fullScreenMap()
    }
    
    func direction() {
        
        let test = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil)
        
        var mapItem = MKMapItem(placemark: test)
        
        mapItem.name = "The way I want to go"
        
        //You could also choose: MKLaunchOptionsDirectionsModeWalking
        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func directionButton(sender: UIButton) {
    
        direction()
    }
//    @IBAction func showCLButton(sender: UIButton) {
        //        locationManager.startUpdatingLocation()

//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.50, longitudeDelta: 0.50))
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func displayAnnotations(hospital: Hospital) {
        let coor = CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        annotation.title = "\(hospital.name)"
        annotation.subtitle = "\(hospital.location)"
        self.mapView.addAnnotation(annotation)
        self.mapView.delegate = self
    }
    
    func zoomToRegion(lat: Double, long: Double) {
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
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
                        newHospital.latitude = result.valueForKey("latitude") as! Double
                        newHospital.longitude = result.valueForKey("longitude") as! Double
                        newHospital.phoneNumber = (result.valueForKey("phone") as? String)!
//                        newHospital.rating = (result.valueForKey("rating") as? Double)!
                        newHospital.imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String)
                        // do not add image if image URL does not exist
                        if let imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String) {
                            newHospital.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayAnnotations(newHospital)
                        })
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
}
