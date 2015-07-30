//
//  RoomBuilderController.swift
//  Behtarin
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit

class RoomBuilderController : UIViewController , UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var childCounterText: UILabel!
    
    @IBOutlet weak var adultCountPicker: UIPickerView!
    
    @IBOutlet weak var childTableView: UITableView!
    
    @IBOutlet weak var addChildButton: UIButton!
    
    internal var hotelGuests : [HotelGuest]!
    
    internal var pickerData : [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init some func
        self.hotelGuests = [HotelGuest]()
        self.inserPickerData()
        adultCountPicker.dataSource = self
        adultCountPicker.delegate = self
        
        //back button action
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "backAndSave:")
        newBackButton.tintColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem = newBackButton
        
        var defaultGuests : HotelGuest = HotelGuest()
        defaultGuests.isChild = false
        defaultGuests.count = 2
        
        self.hotelGuests.append(defaultGuests)

        self.adultCountPicker.selectRow(1, inComponent: 0, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelGuests.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("childCell", forIndexPath: indexPath) as! GuestTableViewCell
        
        return cell
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(pickerData[row])"
    }
    //MARK: did select
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hotelGuests[0].count = row + 1
    }
    
    @IBAction func onAddChildClick(sender: UIButton) {
        
        addChildIntoList()
    }
    
    func addChildIntoList(){
        var child : HotelGuest = HotelGuest()
        child.isChild = true
        child.age = 0
        
        self.hotelGuests.append(child)
        self.childTableView.reloadData()
        let childCount = hotelGuests.count - 1
        self.childCounterText.text = "x\(childCount)"
    }
    
    func inserPickerData(){
        for i in 1...8 {
            pickerData.append(i)
        }
    }
    
    func backAndSave(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
        let delegate : BackAndSaveDelegate = self.storyboard!.instantiateViewControllerWithIdentifier("SearchViewContriller") as! ViewController

        delegate.addRoomIntoList(getGuestListFromBuilderPage())
    }
    
    func getGuestListFromBuilderPage()-> [HotelGuest] {
        var i :Int = 0
        for guest in hotelGuests {
            if guest.isChild {
                let mCell = childTableView.cellForRowAtIndexPath(NSIndexPath(index : 0)) as! GuestTableViewCell
                hotelGuests[i].age = mCell.ageTextField.text.toInt()!
            }
            ++i
        }
        return hotelGuests
    }
    
}
