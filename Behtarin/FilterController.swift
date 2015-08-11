//
//  FilterController.swift
//  Behtarin
//
//  Created by Max Vitruk on 11.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class FilterController: UIViewController {
    
    @IBOutlet weak var filter: UIButton!
    
    var sortDelegate : SortDelegate?
    var array : NSArray = NSArray()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        println("\(self.array.count)")
        
    }
    @IBAction func sortFromLowPrice(sender: UIButton) {
        sortDelegate!.sortByOptions(sortBy("lowRate", ascending: true))
    }

    @IBAction func sortFromHightPrice(sender: UIButton) {
        sortDelegate!.sortByOptions(sortBy("lowRate", ascending: false))
    }
    
    @IBAction func sortByName(sender: UIButton) {
        sortDelegate!.sortByOptions(sortBy("name", ascending: true))
        
    }
    
    func sortBy(key : String, ascending : Bool)-> NSArray{
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        var sortedResults: NSArray = array.sortedArrayUsingDescriptors([descriptor])
        self.dismissViewControllerAnimated(true, completion: nil)
        return sortedResults
    }
}
