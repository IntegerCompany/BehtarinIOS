//
//  SingleHotelViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 03.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class SingleHotelViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var mainText: UITextView!
    
    var hotel : NSDictionary!
    
    var originalNavbarHeight:CGFloat = 0.0
    var minimumNavbarHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subUrl = hotel["thumbNailUrl"] as? String
        var strUrl = baseUrl + subUrl!
        let indexLenght = count(strUrl) - 5
        strUrl = strUrl.substringToIndex(advance(strUrl.startIndex, indexLenght))
        strUrl += sufix

        let url = NSURL(string: strUrl)
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url!.lastPathComponent!.stringByDeletingPathExtension)\".")
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
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }

}
