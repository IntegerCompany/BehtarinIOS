//
//  ViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BackAndSaveDelegate {

    @IBOutlet weak var roomCollectionView: UICollectionView!
    @IBOutlet weak var addRoomButton: UIButton!
    
    internal var hotelRooms:[HotelRoom] = []
    var secondController: RoomBuilderController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("MAIN viewDidLoad")
        let room : HotelRoom = HotelRoom()
        room.adultCount = 2
        room.childern.append(12)
        hotelRooms.append(room)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        println("MAIN viewDidAppear")
        
        var xCordinate : Int = 0
        if hotelRooms.count == 1 {
            xCordinate = 0
        }else{
            xCordinate = ((hotelRooms.count - 1) * 210) - 30
        }
        
        let point = CGPoint(x: xCordinate, y: 0)
        roomCollectionView.reloadData()
        roomCollectionView.setContentOffset(point, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("MAIN viewWillAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //return custom cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.mainCellAdultCount.text = "x\(hotelRooms[indexPath.row].adultCount)"
        cell.mainCellChildCount.text = "x\(hotelRooms[indexPath.row].childern.count)"
        let roomNumber = indexPath.row + 1
        cell.roomCount.text = "Room \(roomNumber)"
        
        return cell
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelRooms.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        addCategory()
    }
    @IBAction func onAddButtonClick(sender: AnyObject) {
        goRoomBuilderController()
    }
    
    func addRoom(room :HotelRoom){
        hotelRooms.append(room)
        println("MAIN hotelRooms : \(hotelRooms.count)")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        secondController = segue.destinationViewController as? RoomBuilderController
        secondController!.delegate = self;
    }

    //GO ROOM BUILDER SCREEN
    func goRoomBuilderController(){
        self.performSegueWithIdentifier("goBuilderScreen", sender: self)
    }
    //MARK: delegate func on back press
    func addRoomIntoList(guests : [HotelGuest]){
        let mRoom : HotelRoom = HotelRoom()
        mRoom.adultCount = guests[0].count
        
        for guest in guests {
            if guest.isChild {
                mRoom.childern.append(guest.age)
            }
        }
        addRoom(mRoom)

        println("MAIN addRoomIntoList")
    }
    
    func addCategory() {
        println("selected")
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("NewCategory") as! UIViewController
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(500,600)
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(100,100,0,0)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
}

