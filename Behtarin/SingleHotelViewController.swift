//
//  SingleHotelViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 03.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class SingleHotelViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var mainText: UITextView!
    
    var hotel : NSDictionary!
    var hotelImages : NSDictionary = NSDictionary()
    var imageArray : NSArray = NSArray()
    var imageCount : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPageInfo()
        self.loadImagesByUrl()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goImageGallery" {
            let imageGalleryController = segue.destinationViewController as! ImageGallaryViewController
            imageGalleryController.imagesArray = sender as! NSArray
        }else{
            let roomController = segue.destinationViewController as! RoomListViewController
            roomController.hotelID = String(self.hotel["hotelId"] as! Int)
        }
    }
    @IBAction func addToWishList(sender: AnyObject) {
        var iterator = 0
        var isInArray : Bool = false
        let def = NSUserDefaults.standardUserDefaults()
        var key = "hotelsWishList"
        var hotelList = [Int]()
        let hotelid = self.hotel["hotelId"] as! Int
        if let testArray : [Int] = def.objectForKey(key) as? [Int]  {
            hotelList = (testArray as [Int])
            for id in hotelList {
                if id == hotelid {
                    hotelList.removeAtIndex(iterator)
                    println("REMOVED AT INDEX \(iterator)")
                    isInArray = true
                }
                ++iterator
            }
            if !isInArray {
                hotelList.append(hotelid)
                println("ADDED AT INDEX \(iterator)")
            }
            def.setObject(hotelList, forKey: key)
        }
        println("\(hotelList.count)")
        def.synchronize()
    
    }

    @IBAction func goImageGallary(sender: UIButton) {
        
        self.performSegueWithIdentifier("goImageGallery", sender: imageArray)
    }
    
    func initImagesIntoCollectionView(hotelImages : NSDictionary) {
        
        var hotelInformationResponse = hotelImages["HotelInformationResponse"] as! NSDictionary
        let hotelImages = hotelInformationResponse["HotelImages"] as! NSDictionary
        self.imageCount = hotelImages["@size"] as! NSString
        self.imageArray = hotelImages["HotelImage"] as! NSArray
        
        self.collectionView.reloadData()

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("hotelImageCell", forIndexPath: indexPath) as! ImageCell
        let imgObj = imageArray[index] as! NSDictionary
        let image = imgObj["thumbnailUrl"] as! String
        let url = NSURL(string: image)
        self.getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                cell.image.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    //Mark : delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageArray.count <= 6 {
            return self.imageArray.count
        }else{
            return 6
        }
        
    }

    func loadImagesByUrl() {
        let url = self.getHotelImagesUrl()
        self.getImagesTask(url)
    }
    
    func initPageInfo(){
        let subUrl = hotel["thumbNailUrl"] as? String
        
        println("\(hotel)")
        
        var strUrl = baseUrl + subUrl!
        let indexLenght = count(strUrl) - 5
        strUrl = strUrl.substringToIndex(advance(strUrl.startIndex, indexLenght))
        strUrl += sufix
        
        let url = NSURL(string: strUrl)
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image.image = UIImage(data: data!)
            }
        }
        
        self.name.text = hotel["name"] as? String
        self.mainText.text = hotel["shortDescription"] as? String
        
        let address = hotel["address1"] as? String
        let city = hotel["city"] as? String
        self.location.text = city! + ", " + address!
        let lowRate = hotel["lowRate"] as? Float
        let priceValue = NSString(format: "%.2f", lowRate!)
        self.price.text = "$ " + (priceValue as String)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // will relayout subviews
        view.setNeedsLayout() // calls viewDidLayoutSubviews
    }
    
    func getHotelImagesUrl() -> String {
        let endpoint = "http://api.ean.com/ean-services/rs/hotel/v3/info?"
        let API_KEY = "7tuermyqnaf66ujk2dk3rkfk"
        let CID = "55505"
        let apiKey : String  = "&apiKey="
        let cid : String = "&cid="
        
        var nowDouble = NSDate().timeIntervalSince1970
        let toHash : String = "\(apiKey)RyqEsq69\(nowDouble)"
        let sigString = ViewController.MD5(toHash)
        
        let sig : String  = "&sig=\(sigString)"
        let intHotelId = hotel["hotelId"] as! Int
        let hotelId = "&hotelId=" + String(intHotelId)
        let options = "&options=HOTEL_IMAGES"

        let url = endpoint
            + cid + CID
            + sig
            + apiKey + API_KEY
            + hotelId
            + options
        
        return url
    }
   
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    func getImagesTask(urlPath : String) {
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
            self.hotelImages = jsonResult
//            println("\(jsonResult)")
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.initImagesIntoCollectionView(jsonResult)
                });
            }
        })
        task.resume()
    }
}
