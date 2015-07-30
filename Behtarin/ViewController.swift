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
    
    var hotelRooms:[HotelRoom] = [HotelRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        var xCordinate : Int = 0
        if hotelRooms.count == 0 {
            xCordinate = 0
        }else{
            xCordinate = (hotelRooms.count * 210) - 30
        }
        
        let room : HotelRoom = HotelRoom()
        room.adultCount = 2
        hotelRooms.append(room)
        
        let point = CGPoint(x: xCordinate, y: 0)
        
        roomCollectionView.setContentOffset(point, animated: true)

        roomCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //return custom cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! CollectionViewCell
//        
//        cell.pintImage.image = UIImage(named: "room_frame.jpeg")
        
        return cell
    }
    //how much cell do we have
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelRooms.count
    }
    @IBAction func onAddButtonClick(sender: AnyObject) {
        goRoomBuilderController()
        //addRoom()
    }
    
    func deleteRoom(){
        roomCollectionView.reloadData()
    }
    func addRoom(){

        let room : HotelRoom = HotelRoom()
        room.adultCount = 2
        hotelRooms.append(room)

    }
    //GO ROOM BUILDER SCREEN
    func goRoomBuilderController(){
        self.performSegueWithIdentifier("goBuilderScreen", sender: self)
    }
    //MARK: delegate func on back press
    func addRoomIntoList(){
        addRoom()
    }

}

