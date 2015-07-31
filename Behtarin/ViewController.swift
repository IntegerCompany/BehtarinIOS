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
        cell.editButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelRooms.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    @IBAction func onAddButtonClick(sender: AnyObject) {
        goRoomBuilderController()
    }
    
    func addRoom(room :HotelRoom){
        hotelRooms.append(room)
        println("MAIN hotelRooms : \(hotelRooms.count)")
    }
    func editRoom(room :HotelRoom, row : Int){
        hotelRooms[row] = room
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        secondController = segue.destinationViewController as? RoomBuilderController
        secondController!.delegate = self;
        if sender is UIButton {
            secondController!.isEditAction = true
            let editedRow = (sender as! UIButton).tag
            secondController!.editedRow = editedRow
            secondController!.hotelGuests = roomToGuestList(hotelRooms[editedRow])
        }
    }

    //GO ROOM BUILDER SCREEN
    func goRoomBuilderController(){
        self.performSegueWithIdentifier("goBuilderScreen", sender: self)
    }
    //MARK: delegate func on back press
    func addRoomIntoList(guests : [HotelGuest], isEditAction : Bool, editedRow : Int){
        let mRoom : HotelRoom = HotelRoom()
        mRoom.adultCount = guests[0].count
        
        for guest in guests {
            if guest.isChild {
                mRoom.childern.append(guest.age)
            }
        }
        if isEditAction {
            editRoom(mRoom, row: editedRow)
            println("MAIN EditRoomIntoList")
        }else{
            addRoom(mRoom)
            println("MAIN AddRoomIntoList")
        }
    }
    func buttonClicked(sender: UIButton){
        println("Edit button pressed  \(sender.tag)")
        self.performSegueWithIdentifier("goBuilderScreen", sender: sender)
    }
    
    func roomToGuestList(room : HotelRoom)->[HotelGuest]{
        var hotelGuests = [HotelGuest]()
        let adult = HotelGuest(); adult.isChild = false ; adult.count = room.adultCount
        hotelGuests.append(adult)
        
        for var i = 0; i < room.childern.count; ++i {
            let child = HotelGuest(); child.isChild = true ; child.age = room.childern[i]
            hotelGuests.append(child)
        }
        return hotelGuests
    }
}

