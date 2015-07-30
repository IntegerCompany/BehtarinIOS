//
//  SimleObjects.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pintImage: UIImageView!
    @IBOutlet weak var mainCellChildCount: UILabel!
    @IBOutlet weak var mainCellAdultCount: UILabel!
}

class GuestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var childImage: UIImageView!
}

class HotelRoom {
    
    var adultCount:Int
    var childern: [Int]
    
    internal init(){
        self.adultCount = 2
        self.childern = [Int]()
    }
    
}

class HotelGuest {
    
    var isChild :Bool = Bool()
    var age : Int = Int()
    var count: Int = Int()
    
    internal init(){
        
        self.isChild = false
        self.age = 0
        self.count = 0
        
    }
}
