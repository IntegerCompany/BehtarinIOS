//
//  MyDelegates.swift
//  Behtarin
//
//  Created by Max Vitruk on 29.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import Foundation

protocol BackAndSaveDelegate {
    
    func addRoomIntoList(guests : [HotelGuest], isEditAction : Bool, editedRow : Int)
}

protocol EditButtonDelegate {
    func editThisRow(row : Int)
}