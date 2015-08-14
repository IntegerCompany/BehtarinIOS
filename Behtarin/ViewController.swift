//
//  ViewController.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit
import CryptoSwift

public class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BackAndSaveDelegate, LoadCallBack  {

    @IBOutlet weak var starsRating: CosmosView!
    @IBOutlet weak var checkIn: UITextField!
    @IBOutlet weak var checkOut: UITextField!
    @IBOutlet weak public var hotelName: UITextField!
    @IBOutlet weak var roomCollectionView: UICollectionView!
    @IBOutlet weak var addRoomButton: UIButton!
    
    internal static var hotelRooms:[HotelRoom] = []
    internal static var mArrivalDate = ""
    internal static var mDepartureDate = ""
    
    var secondController: RoomBuilderController?
    var hotelsResult : NSDictionary = NSDictionary()
    
    var mLoader : Loader!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mLoader = Loader(callBack: self)
        
        let room : HotelRoom = HotelRoom()
        room.adultCount = 2
        ViewController.hotelRooms.append(room)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        
        var xCordinate : Int = 0
        if ViewController.hotelRooms.count == 1 {
            xCordinate = 0
        }else{
            xCordinate = ((ViewController.hotelRooms.count - 1) * 210) - 30
        }
        
        let point = CGPoint(x: xCordinate, y: 0)
        roomCollectionView.reloadData()
        roomCollectionView.setContentOffset(point, animated: true)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("MAIN viewWillAppear")
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : LOAD DID FINISH
    public func loadDidFinish(sender: AnyObject) {
        
        self.hotelsResult = sender as! NSDictionary
        self.goResultListController()
    }
    //return custom cell
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.mainCellAdultCount.text = "x\(ViewController.hotelRooms[indexPath.row].adultCount)"
        cell.mainCellChildCount.text = "x\(ViewController.hotelRooms[indexPath.row].childern.count)"
        let roomNumber = indexPath.row + 1
        cell.roomCount.text = "Room \(roomNumber)"
        cell.editButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    //how much cell do we have
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.hotelRooms.count
    }
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    @IBAction func onAddButtonClick(sender: AnyObject) {
        goRoomBuilderController()
    }
    
    func addRoom(room :HotelRoom){
        ViewController.hotelRooms.append(room)
        println("MAIN hotelRooms : \(ViewController.hotelRooms.count)")
    }
    func editRoom(room :HotelRoom, row : Int){
        ViewController.hotelRooms[row] = room
    }
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sIdentifier = segue.identifier
        
        if sIdentifier == "goToHotelList" {
            var hotelsListController = segue.destinationViewController as? TabController
            hotelsListController?.hotels = self.hotelsResult
            
        } else if sIdentifier == "goBuilderScreen" {
            
            secondController = segue.destinationViewController as? RoomBuilderController
            secondController!.delegate = self;
            if sender is UIButton {
                secondController!.isEditAction = true
                let editedRow = (sender as! UIButton).tag
                secondController!.editedRow = editedRow
                secondController!.hotelGuests = roomToGuestList(ViewController.hotelRooms[editedRow])
            }
        }
    }

    //MARK:  GO ROOM BUILDER SCREEN
    func goRoomBuilderController(){
        self.performSegueWithIdentifier("goBuilderScreen", sender: self)
    }
    //MARK:  GO HOTELS LIST SCREEN
    public func goResultListController(){
        self.performSegueWithIdentifier("goToHotelList", sender: self)
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
        
        self.mLoader.getFromUrl(makeURLWithParameters())
        
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
        dateFormatter.dateFormat = "MM/dd/yyyy"
        checkIn.text = dateFormatter.stringFromDate(sender.date)
    }
    func handleDatePickerCheckOut(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        checkOut.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func post(urlPath : String) {
        var url : NSString = urlPath
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var searchURL : NSURL = NSURL(string: urlStr as String)!
        println(searchURL)
        let session = NSURLSession.sharedSession()
        
        var error:NSError?
        
        let task = session.dataTaskWithURL(searchURL, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                println(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            //println("\(jsonResult)")
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.hotelsResult = jsonResult
                    self.goResultListController()
                });
            }
        })
        task.resume()
    }
    
    public func makeURLWithParameters()->String{
        
        let API_KEY = "7tuermyqnaf66ujk2dk3rkfk"
        let CID = "55505"
//        
//        let mCity:String = hotelName.text
//        ViewController.mArrivalDate = checkIn.text
//        ViewController.mDepartureDate = checkOut.text
//        let mRoom = ViewController.makeRoomString()
        
        let mCity:String = "London"
        ViewController.mArrivalDate = "08/20/2015"
        ViewController.mDepartureDate = "08/20/2015"
        let mRoom = ViewController.makeRoomString()

        
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
        let sigString = ViewController.MD5(toHash)
        
        let sig : String  = "&sig=\(sigString)"
        let minorRev : String  = "&minorRev=30"
        let room : String  = "&room1="
    
        
        let urlConcate : String = "http://api.ean.com/ean-services/rs/hotel/v3/list? \(apiKey) \(API_KEY) \(cid) \(CID) \(sig) \(customerIpAddress) \(currencyCode) \(customerSessionID) \(minorRev) \(locale) \(city) \(mCity) \(arrivalDate) \(ViewController.mArrivalDate) \(departureDate) \(ViewController.mDepartureDate) \(room) \(mRoom)"
        
        let url = urlConcate.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return url

    }
    internal static func makeRoomString() -> String {
        var roomString : String = ""
        var iterator = 1
        for room in ViewController.hotelRooms {
            roomString += "&room\(iterator)=\(room.adultCount)"
            if room.childern.count != 0 {
                roomString += ","
                for child in room.childern {
                    roomString += "\(child),"
                }
            }
            iterator++
        }
        
        return roomString
    }
    internal static func MD5(stringData : String)->String{
        let data = (stringData as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let hash = data!.md5()
        
        return hash!.hexString
    }
}

