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
    
}

class GuestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var age: UIView!
    
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
    
    var isChild :Bool!
    var age : Int!
    var count: Int!
    
    internal init(isChild : Bool, ageOrCount : Int){
        self.isChild = isChild
        
        if isChild {
            self.age = ageOrCount
        }else{
            self.count = ageOrCount
        }
        self.isChild = false
        self.age = 0
        self.count = 2
    }
}
