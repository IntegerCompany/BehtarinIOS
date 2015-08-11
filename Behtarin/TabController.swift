//
//  TabController.swift
//  Behtarin
//
//  Created by Max Vitruk on 11.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class TabController: UITabBarController, UIPopoverPresentationControllerDelegate {
    
    var hotels : NSDictionary = NSDictionary()
    var hotelSummary : NSArray = NSArray()
    var firstViewController:HotelListViewController!
    var secondViewController : HotelGridViewController!
    
    var popoverContent : FilterController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //INIT POPOVER CONTENT
        popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("filterView") as? FilterController
        
        var filter = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "addCategory:")
        self.navigationItem.rightBarButtonItem = filter
        
        var hotelResponce : NSDictionary = hotels["HotelListResponse"] as! NSDictionary
        if let hotelResponseList = hotelResponce["HotelList"] as? NSDictionary {
            var hotelList : NSDictionary = hotelResponce["HotelList"] as! NSDictionary
            self.hotelSummary = hotelList["HotelSummary"] as! NSArray
        }
        
        var firstStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        firstViewController = firstStoryboard.instantiateViewControllerWithIdentifier("hotelList") as! HotelListViewController

        secondViewController = firstStoryboard.instantiateViewControllerWithIdentifier("hotelGrid") as! HotelGridViewController
        
        popoverContent?.sortDelegate = self.firstViewController
        popoverContent?.array = self.hotelSummary
        
        self.viewControllers = [firstViewController, secondViewController]
        
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch item.tag  {
        case 0:
            popoverContent?.sortDelegate = self.firstViewController
            break
        case 1:
            popoverContent?.sortDelegate = self.secondViewController
            break
        default:
            popoverContent?.sortDelegate = self.firstViewController
            break
        }

    }
    func checkAvalibility(sender: Int){
        self.performSegueWithIdentifier("checkAvailability1", sender: String(sender))
    }
    func readMore(indexPath : Int){
        self.performSegueWithIdentifier("readMoreScreen", sender: indexPath)
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
    
    func addCategory(sender : UIBarButtonItem) {
        
        popoverContent!.modalPresentationStyle = UIModalPresentationStyle.Popover
        popoverContent!.preferredContentSize = CGSizeMake(180,190)
        let nav = popoverContent!.popoverPresentationController
        nav?.delegate = self
        nav?.permittedArrowDirections = .Up
        nav?.sourceView = self.view
        let width = self.view.frame.width
        nav?.sourceRect = CGRectMake(width, 50, 0, 0)
        
        self.navigationController?.presentViewController(popoverContent!, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

}
