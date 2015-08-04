//
//  HotelListViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 03.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

let cellID = "hotelCell"
let baseUrl = "http://images.travelnow.com"
let sufix = "b.jpg"
let tripSufix = "png"

class HotelListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var hotels : NSDictionary!
    var hotelSummary : NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var hotelResponce : NSDictionary = hotels["HotelListResponse"] as! NSDictionary
        var hotelList : NSDictionary = hotelResponce["HotelList"] as! NSDictionary
        
        self.hotelSummary = hotelList["HotelSummary"] as! NSArray

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "readMoreScreen" {
            let singleViewController = segue.destinationViewController as! SingleHotelViewController
            let rowIndex = (sender as! NSIndexPath).row
            singleViewController.hotel = hotelSummary[rowIndex] as! NSDictionary
        }
    }
    
    //return custom cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! HotelCell
        var i = indexPath.row
    
        let subUrl = (hotelSummary[i] as! NSDictionary)["thumbNailUrl"] as? String
        var strUrl = baseUrl + subUrl!
        let indexLenght = count(strUrl) - 5
        strUrl = strUrl.substringToIndex(advance(strUrl.startIndex, indexLenght))
        strUrl += sufix
        
        let url = NSURL(string: strUrl)
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url!.lastPathComponent!.stringByDeletingPathExtension)\".")
                cell.image.image = UIImage(data: data!)
            }
        }
        
        cell.name.text = (hotelSummary[i] as! NSDictionary)["name"] as? String
        cell.mainText.text = (hotelSummary[i] as! NSDictionary)["shortDescription"] as? String

        let address = (hotelSummary[i] as! NSDictionary)["address1"] as? String
        let city = (hotelSummary[i] as! NSDictionary)["city"] as? String
        cell.location.text = city! + ", " + address!
        let lowRate = (hotelSummary[i] as! NSDictionary)["lowRate"] as? Float
        let price = NSString(format: "%.2f", lowRate!)
        cell.price.text = "$ " + (price as String)
        let likesCount = String((hotelSummary[i] as! NSDictionary)["tripAdvisorReviewCount"] as! Int)
        cell.likes.text = likesCount
        
        return cell
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotelSummary.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("readMoreScreen", sender: indexPath)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }

}

