//
//  RoomEntry.swift
//  OAuthTestV3
//
//  Created by User on 12/04/15.
//  Copyright (c) 2015 Avans. All rights reserved.
//

import Foundation

class RoomEntry {
    var date: String = "NOT_SET"
    var collegeHour: Int = -1
    var classRoom: String = "NOT_SET"
    var roomSize: Int = -1
    var type: String = "NOT_SET"
    var occupied: Bool = false
    var time: String = "NOT_SET"
    
    
    func setCollegeHour(collegeHour: Int) {
        self.collegeHour = collegeHour
    }
    
    func setDate(date: String) {
        self.date = date
    }
    
    func setClassRoom(classRoom: String) {
        self.classRoom = classRoom
    }
    
    func setRoomSize(roomSize: Int) {
        self.roomSize = roomSize
    }
    
    func getCollegeHour() -> Int {
        return self.collegeHour
    }
    
    func getDate() -> String {
        return self.date
    }
    
    func getClassRoom() -> String {
        return self.classRoom
    }
    
    func getRoomSize() -> Int {
        return self.roomSize
    }
    
    func getTime() -> String {
        switch(collegeHour) {
        case 0:
            return "08:00 - 08:45"
        case 1:
            return "08:45 - 09:30"
        case 2:
            return "09:35 - 10:20"
        case 3:
            return "10:35 - 11:20"
        case 4:
            return "11:25 - 12:10"
        case 5:
            return "12:15 - 13:00"
        case 6:
            return "13:00 - 13:45"
        case 7:
            return "13:50 - 14:35"
        case 8:
            return "14:40 - 15:25"
        case 9:
            return "15:40 - 16:25"
        case 10:
            return "16:30 - 17:15"
        case 11:
            return "17:15 - 18:00"
        case 12:
            return "18:00 - 18:45"
        case 13:
            return "18:45 - 19:30"
        case 14:
            return "19:30 - 20:15"
        case 15:
            return "20:30 - 21:15"
        case 16:
            return "21:15 - 22:00"
        default:
            println(collegeHour)
            return "??:?? - ??:??"
        }
    }
    
}
