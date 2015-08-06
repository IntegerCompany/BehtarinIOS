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

class HotelListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var hotels : NSDictionary = NSDictionary()
    var hotelSummary : NSArray = NSArray()

    @IBOutlet weak var errorMassage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.hidesBarsOnSwipe = true
        
        var filter = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "addCategory:")
        self.navigationItem.rightBarButtonItem = filter
        
        var hotelResponce : NSDictionary = hotels["HotelListResponse"] as! NSDictionary
        if let hotelResponseList = hotelResponce["HotelList"] as? NSDictionary {
            var hotelList : NSDictionary = hotelResponce["HotelList"] as! NSDictionary
            self.hotelSummary = hotelList["HotelSummary"] as! NSArray
            errorMassage.hidden = true
        }else{
            errorMassage.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "readMoreScreen" {
            let singleViewController = segue.destinationViewController as! SingleHotelViewController
            let rowIndex = sender as! Int
            singleViewController.hotel = hotelSummary[rowIndex] as! NSDictionary
        }else if segue.identifier == "checkAvailability1" {
            let roomController = segue.destinationViewController as! RoomListViewController
            roomController.hotelID = sender as! String
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
        
        cell.ckeckAvailability.tag = (hotelSummary[i] as! NSDictionary)["hotelId"] as! Int
        cell.ckeckAvailability.addTarget(self, action: "checkAvalibility:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.readMore.tag = indexPath.row
        cell.readMore.addTarget(self, action: "readMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotelSummary.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.readMore(indexPath.row)
    }
    func readMoreAction(sender:UIButton){
        readMore(sender.tag)
    }
    func readMore(indexPath : Int){
        self.performSegueWithIdentifier("readMoreScreen", sender: indexPath)
    }
    func checkAvalibility(sender:UIButton){
        self.performSegueWithIdentifier("checkAvailability1", sender: String(sender.tag))
    }
    
    func addCategory(sender : UIBarButtonItem) {
        
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("filterView") as! UIViewController
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        popoverContent.preferredContentSize = CGSizeMake(100,100)
        let nav = popoverContent.popoverPresentationController
        nav?.delegate = self
        nav?.permittedArrowDirections = .Up
        nav?.sourceView = self.view
        let width = self.view.frame.width
        nav?.sourceRect = CGRectMake(width, 50, 0, 0)
        
        self.navigationController?.presentViewController(popoverContent, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
}

