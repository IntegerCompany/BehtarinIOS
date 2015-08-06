//
//  ImageGallaryViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 06.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class ImageGallaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var imagesArray : NSArray = NSArray()
    internal var startWithImage : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgObj = imagesArray[startWithImage] as! NSDictionary
        let image = (imgObj)["url"] as! String
        let url = NSURL(string: image)
        self.caption.text = imgObj["caption"] as? String
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image.image = UIImage(data: data!)
            }
        }
    }
    @IBAction func goBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        let imgObj = imagesArray[index] as! NSDictionary
        let image = (imgObj)["thumbnailUrl"] as! String
        let url = NSURL(string: image)
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                cell.image.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    //Mark : delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index2 = indexPath.row
        println("\(index2)")
        let imgObj2 = imagesArray[index2] as! NSDictionary
        let image2 = imgObj2["url"] as! String
        self.caption.text = imgObj2["caption"] as? String
        let url = NSURL(string: image2)
        getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image.image = UIImage(data: data!)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
}
