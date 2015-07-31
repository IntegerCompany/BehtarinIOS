//
//  ViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BackAndSaveDelegate {

    @IBOutlet weak var starsRating: CosmosView!
    @IBOutlet weak var checkIn: UITextField!
    @IBOutlet weak var checkOut: UITextField!
    @IBOutlet weak var hotelName: UITextField!
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
    @IBAction func onSearchButoonClick(sender: UIButton) {
        
        //self.post(["username":"jameson", "password":"password"], url: "http://localhost:4567/login")
        
    }
    
    @IBAction func datePickerCall(sender: UITextField) {
        var funcName:String = "handleDatePickerCheckOut:"
        if sender == self.checkIn {
            funcName = "handleDatePickerCheckIn:"
        }
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector(funcName), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePickerCheckIn(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkIn.text = dateFormatter.stringFromDate(sender.date)
    }
    func handleDatePickerCheckOut(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        checkOut.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func post(urlPath : String) {
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        
        var error:NSError?
        
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                println(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }else{
                println("succes !!!")
            }
        })
        task.resume()
    }
    
    func makeURLWithParameters()->String{
        
        let API_KEY = "7tuermyqnaf66ujk2dk3rkfk"
        let mCity:String = hotelName.text
        let mArrivalDate : String = checkIn.text
        let mDepartureDate : String = checkOut.text
        //MARK:HARDCODE
        let mRoom = 1
        
        let apiKey : String  = "&apiKey="
        let cid : String = "&cid="
        let locale :String = "&locale=enUS"
        let customerSessionID : String  = "&customerSessionID=1"
        let customerIpAddress : String  = "&customerIpAddress=193.93.219.63"
        let arrivalDate : String  = "&arrivalDate="
        let currencyCode : String  = "&currencyCode=USD"
        let departureDate : String  = "&departureDate="
        let city : String  = "&destinationString="
        
        var nowDouble = NSDate().timeIntervalSince1970
        let toHash : String = "\(apiKey)RyqEsq69\(nowDouble)"
        //let sigString = MD5(toHash)
        
        //let sig : String  = "&sig=\(sigString)"
        let minorRev : String  = "&minorRev=30"
        let room : String  = "&room1="
    
        
        
//        let url : String = "http://api.ean.com/ean-services/rs/hotel/v3/list? \(apiKey)\(API_KEY)\(cid)\(CID)\(sig)\(customerIpAddress)\(currencyCode)\(customerSessionID)\(minorRev)\(locale)\(city)\(mCity)\(arrivalDate)\(mArrivalDate)\(departureDate)\(mDepartureDate)\(room)\(mRoom)"
        
        //return url
        return " "
    }
}

