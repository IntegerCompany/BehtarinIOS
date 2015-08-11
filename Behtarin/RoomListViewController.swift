//
//  RoomListViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 05.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

let roomCellID = "roomCell"
let baseRoomUrl = "http://api.ean.com/ean-services/rs/hotel/v3/avail?"
let dollar = "$ "

class RoomListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var roomList : NSArray = NSArray()
    var roomResult = NSDictionary()
    var hotelID : String = "1"
    var location : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAvailability(makeURLWithParameters())
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(roomCellID, forIndexPath: indexPath) as! RoomCell
        let room = roomList[indexPath.row] as! NSDictionary
        
        cell.name.text = room["roomTypeDescription"] as? String
        let rateInfo = room["RateInfo"] as! NSDictionary
        let chargeableRateInfo = rateInfo["ChargeableRateInfo"] as! NSDictionary
        let promo : NSString = rateInfo["@promo"] as! NSString
        var price: String = (chargeableRateInfo["@averageBaseRate"] as? NSString)! as String
        price = dollar + price
        if promo == "true"{
            let hidenPrice: String = (chargeableRateInfo["@averageRate"] as? NSString)! as String
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.price.attributedText = attributeString
            cell.price.textColor = UIColor.grayColor()
            cell.hidenPrice.text = dollar + hidenPrice
            cell.hidenPrice.hidden = false
        }else{
            cell.hidenPrice.hidden = true
            cell.price.textColor = UIColor.blackColor()
            cell.price.text = price
        }
        let count = String(room["quotedOccupancy"] as! Int)
        cell.adultCount.text = "x" + count
        
        let bedTypes = room["BedTypes"] as! NSDictionary
        let bedSize = bedTypes["@size"] as! NSString
        cell.bedCount.text = "x" + (bedSize as String)
        var description : String = ""
        if let bedType = bedTypes["BedType"] as? NSArray {
            for bed in bedType {
                description = description + (bed["description"] as! String) + "\n"
            }
        }else{
            let bedType = bedTypes["BedType"] as! NSDictionary
            description = bedType["description"] as! String
        }
        
        cell.bedsList.text = description
        
        var rUrl : String = "awa"
        if let roomImages = room["RoomImages"] as? NSDictionary{
            let imgListSize = (roomImages["@size"] as! NSString).integerValue
            if imgListSize > 1 {
                let images = roomImages["RoomImage"] as! NSArray
                rUrl = (images.firstObject as! NSDictionary)["url"] as! String
            }else{
                let images2 = roomImages["RoomImage"] as! NSDictionary
                rUrl = images2["url"] as! String
            }
            for index in 1...5 {
                rUrl = dropLast(rUrl)
            }
            rUrl += sufix
            
            let url = NSURL(string: rUrl)
            getDataFromUrl(url!) { data in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.image.image = UIImage(data: data!)
                }
            }
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func checkAvailability(urlPath : String) {
        
        var url : NSString = urlPath
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var searchURL : NSURL = NSURL(string: urlStr as String)!
        println(searchURL)
        let session = NSURLSession.sharedSession()
        
        var error:NSError?
        
        let task = session.dataTaskWithURL(searchURL, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                println(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            self.roomList = ((jsonResult["HotelRoomAvailabilityResponse"] as! NSDictionary)["HotelRoomResponse"])as! NSArray
            
            //println("\(jsonResult)")
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                });
            }
        })
        task.resume()
    }
    
    func makeURLWithParameters()->String{
        
        let API_KEY = "7tuermyqnaf66ujk2dk3rkfk"
        let CID = "55505"
        let apiKey : String  = "&apiKey="
        let cid : String = "&cid="
        let arrivalDate : String  = "&arrivalDate="
        let currencyCode : String  = "&currencyCode=USD"
        let departureDate : String  = "&departureDate="
        let hotelId = "&hotelId="
        
        var nowDouble = NSDate().timeIntervalSince1970
        let toHash : String = "\(apiKey)RyqEsq69\(nowDouble)"
        let sigString = ViewController.MD5(toHash)
        
        let sig : String  = "&sig=\(sigString)"
        let minorRev : String  = "&minorRev=30"
        let room : String  = "&room1="
        
        
        let urlConcate : String = baseRoomUrl
            + cid + CID
            + sig
            + apiKey + API_KEY
            + hotelId
            + self.hotelID
            + arrivalDate + ViewController.mArrivalDate
            + departureDate + ViewController.mDepartureDate
            + "&includeRoomImages=true"
            + ViewController.makeRoomString()
        
        return urlConcate
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
}
