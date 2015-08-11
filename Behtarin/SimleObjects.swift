//
//  SimleObjects.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var roomCount: UILabel!
    @IBOutlet weak var pintImage: UIImageView!
    @IBOutlet weak var mainCellChildCount: UILabel!
    @IBOutlet weak var mainCellAdultCount: UILabel!
}
class ImageCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
}
class GuestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var childAgeLable: UILabel!
    @IBOutlet weak var childImage: UIImageView!
}
class RoomCell : UICollectionViewCell {
    
    @IBOutlet weak var bedsList: UILabel!
    @IBOutlet weak var bedCount: UILabel!
    @IBOutlet weak var adultCount: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hidenPrice: UILabel!
}
class HotelCell : UICollectionViewCell {
    

    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var ckeckAvailability: UIButton!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var tripAdvisor: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
}

class HotelListCell : UITableViewCell {
    
    
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var ckeckAvailability: UIButton!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var tripAdvisor: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!

    
}

class Hotel{
    
    var name:String = ""
    var location : String = ""
    var image : String = ""
    var description : String = ""
    var likes : Int = 0
    var price : Float = 0.0

    
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
