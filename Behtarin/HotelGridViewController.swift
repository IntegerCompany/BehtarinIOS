//
//  HotelGridViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 11.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class HotelGridViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SortDelegate {
    
    var hotels : NSDictionary = NSDictionary()
    var hotelSummary : NSArray = NSArray()
    let cellID = "hotelListCell"
    
    @IBOutlet weak var errorMassage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hotelSummary = (self.tabBarController as! TabController).hotelSummary
        self.navigationController?.hidesBarsOnSwipe = true
        
        var filter = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "addCategory:")
        self.navigationItem.rightBarButtonItem = filter
        
        if hotelSummary.count == 0 {
            self.errorMassage.hidden = false
        }else{
            self.errorMassage.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.hotelSummary = (self.tabBarController as! TabController).hotelSummary
        tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HotelListCell
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
                cell.hotelImage.image = UIImage(data: data!)
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        (self.tabBarController as! TabController).readMore(indexPath.row)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotelSummary.count
    }
    //MARK : SORT DELEGATE
    func sortByOptions(array: NSArray) {
        (self.tabBarController as! TabController).hotelSummary = array
        self.hotelSummary = array
        self.tableView.reloadData()
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
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
