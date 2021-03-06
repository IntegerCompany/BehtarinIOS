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

class HotelListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SortDelegate {
    
    var hotels : NSDictionary = NSDictionary()
    var hotelSummary : NSArray = NSArray()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorMassage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hotelSummary = (self.tabBarController as! TabController).hotelSummary
        self.navigationController?.hidesBarsOnSwipe = true
        
        if hotelSummary.count == 0 {
            self.errorMassage.hidden = false
        }else{
            self.errorMassage.hidden = true
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.hotelSummary = (self.tabBarController as! TabController).hotelSummary
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.ckeckAvailability.tag = (hotelSummary[i] as! NSDictionary)["hotelId"] as! Int
        cell.ckeckAvailability.addTarget(self, action: "checkAvalibilityAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.readMore.tag = indexPath.row
        cell.readMore.addTarget(self, action: "readMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    //MARK : SORT DELEGATE 
    func sortByOptions(array: NSArray) {
        (self.tabBarController as! TabController).hotelSummary = array
        self.hotelSummary = array
        self.collectionView.reloadData()
        self.collectionView.contentOffset = CGPointMake(0, 0 - self.collectionView.contentInset.top)
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotelSummary.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        (self.tabBarController as! TabController).readMore(indexPath.row)
    }
    func readMoreAction(sender:UIButton){
        (self.tabBarController as! TabController).readMore(sender.tag)
    }
    
    func checkAvalibilityAction(sender:UIButton){
        (self.tabBarController as! TabController).checkAvalibility(sender.tag)
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
}

