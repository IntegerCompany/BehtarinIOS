//
//  FileterViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 11.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class FileterViewController: UIViewController {
    
    @IBOutlet weak var minRatePicker: UIPickerView!
    @IBOutlet weak var maxRatePicker: UIPickerView!
    
    @IBOutlet weak var trip1: UISwitch!
    @IBOutlet weak var trip2: UISwitch!
    @IBOutlet weak var trip3: UISwitch!
    @IBOutlet weak var trip4: UISwitch!
    @IBOutlet weak var trip5: UISwitch!
    
    internal var pickerData : [Int] = [Int]()
    var minRate : Int = 0
    var maxRate : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...14{
            pickerData.append(i*50)
        }
        
        
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(pickerData[row])"
    }
    //MARK: did select
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.minRate = row
            println("minRate : \(row * 50)")
        }else{
            self.maxRate = row
            println("maxRate : \(row * 50)")
        }
    }

//    
//    func makeFilterString()->String {
//        var filter = ""
//
//        filter = "&minRate=" + filterParams.getMinPrice() + "&maxRate=" + filterParams.getMaxPrice() +
//            "&minStarRating=" + (filterParams.getMinStarRate()+1) + "&maxStarRating=" + (filterParams.getMaxStarRate()+1) +
//            "&minTripAdvisorRating=" + (filterParams.getMinTripRate()+1) + "&maxTripAdvisorRating=" + (filterParams.getMaxTripRate()+1);
//        
//        return filter
//    }
    /**
    
    private String makeFilterString() {
    String filter = "";
    if (filterParams == null) {
    return filter;
    }
    filter = filter + "&minRate=" + filterParams.getMinPrice() + "&maxRate=" + filterParams.getMaxPrice() +
    "&minStarRating=" + (filterParams.getMinStarRate()+1) + "&maxStarRating=" + (filterParams.getMaxStarRate()+1) +
    "&minTripAdvisorRating=" + (filterParams.getMinTripRate()+1) + "&maxTripAdvisorRating=" + (filterParams.getMaxTripRate()+1);
    return filter;
    }
    
    */
}
