//
//  filterViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//


import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var consultingFeeSlider: UISlider!
    

    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
   
    @IBAction func distanceSliderChanged(sender: UISlider) {
        let tbvc = self.tabBarController as! MainTabController
        tbvc.filterModel.distance = distanceSlider.value
    }
    
    override func viewWillDisappear(animated: Bool) {
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}