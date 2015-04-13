//
//  ViewController.swift
//  OAuthTestV3
//
//  Created by User on 11/04/15.
//  Copyright (c) 2015 Avans. All rights reserved.
//

import UIKit
import OAuthSwift

class EntryTableViewCell : UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func loadItem(#time: String, status: String) {
        if status == "BEZET" {
            self.statusLabel.backgroundColor = UIColor.redColor()
        } else if status == "VRIJ" {
            self.statusLabel.backgroundColor = UIColor.greenColor()
        } else {
            self.statusLabel.backgroundColor = UIColor.grayColor()
        }
        timeLabel.text = time
        statusLabel.text = status
    }
}

class ViewController: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate //to retrieve oauth
    var myData = Dictionary<String, Dictionary<String, Array<RoomEntry>>>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerView: UIPickerView!
    @IBOutlet weak var roomPickerView: UIPickerView!
    @IBAction func testMethod(sender: AnyObject) {
        fireMethod()
    }
    
    
    var defaultItems: [(String, String)] = [
        ("08:00 - 08:45", "ONBEKEND"),
        ("08:45 - 09:30", "ONBEKEND"),
        ("09:35 - 10:20", "ONBEKEND"),
        ("10:35 - 11:20", "ONBEKEND"),
        ("11:25 - 12:10", "ONBEKEND"),
        ("12:15 - 13:00", "ONBEKEND"),
        ("13:00 - 13:45", "ONBEKEND"),
        ("13:50 - 14:35", "ONBEKEND"),
        ("14:40 - 15:25", "ONBEKEND"),
        ("15:40 - 16:25", "ONBEKEND"),
        ("16:30 - 17:15", "ONBEKEND"),
        ("17:15 - 18:00", "ONBEKEND"),
        ("18:00 - 18:45", "ONBEKEND"),
        ("18:45 - 19:30", "ONBEKEND"),
        ("19:30 - 20:15", "ONBEKEND"),
        ("20:30 - 21:15", "ONBEKEND"),
        ("21:15 - 22:00", "ONBEKEND")
    ]
    var items: [(String,String)] = [
        ("08:00 - 08:45", "ONBEKEND"),
        ("08:45 - 09:30", "ONBEKEND"),
        ("09:35 - 10:20", "ONBEKEND"),
        ("10:35 - 11:20", "ONBEKEND"),
        ("11:25 - 12:10", "ONBEKEND"),
        ("12:15 - 13:00", "ONBEKEND"),
        ("13:00 - 13:45", "ONBEKEND"),
        ("13:50 - 14:35", "ONBEKEND"),
        ("14:40 - 15:25", "ONBEKEND"),
        ("15:40 - 16:25", "ONBEKEND"),
        ("16:30 - 17:15", "ONBEKEND"),
        ("17:15 - 18:00", "ONBEKEND"),
        ("18:00 - 18:45", "ONBEKEND"),
        ("18:45 - 19:30", "ONBEKEND"),
        ("19:30 - 20:15", "ONBEKEND"),
        ("20:30 - 21:15", "ONBEKEND"),
        ("21:15 - 22:00", "ONBEKEND")
    ]
    
    var selectedDate: String = "NOT_SET"
    var selectedRoom: String = "NOT_SET"
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:EntryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! EntryTableViewCell
        
        // this is how you extract values from a tuple
        var (time,status) = items[indexPath.row]
        
        cell.loadItem(time: time, status: status)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.tag = 0
        roomPickerView.tag = 1
        fireMethod()
        datePickerView.selectRow(0, inComponent: 0, animated: false)
        roomPickerView.selectRow(0, inComponent: 0, animated: false)
        
        
        
        var nib = UINib(nibName: "EntryTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fireMethod() {
        var parameters =  Dictionary<String, AnyObject>()
        
        var currentStartDate: String = "2015-03-05"
        var currentEndDate: String = "2015-03-12"
        var rooms: String = "OB2"
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let dateStartNotNill = defaults.objectForKey("dateStart") as? String {
            currentStartDate = defaults.objectForKey("dateStart") as! String
        }
        if let dateEndNotNill = defaults.objectForKey("dateEnd") as? String {
            currentEndDate = defaults.objectForKey("dateEnd") as! String
        }
        if let roomsNotNill = defaults.objectForKey("rooms") as? String {
            rooms = defaults.objectForKey("rooms") as! String
        }
        
        
        parameters["start"] = currentStartDate
        parameters["end"] = currentEndDate
        parameters["filter"] = rooms
        parameters["type"] = "all"
        //items.removeAll()
        delegate.oauthswift.client.get("https://publicapi.avans.nl/oauth/lokaalbeschikbaarheid/", parameters: parameters,
            success: {
                data, response in
                let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                let dataArray = jsonDict as! NSArray
                for  item in dataArray {
                    let obj = item as! NSDictionary
                    var date: String = "NOT_SET"
                    var collegeHour: Int = -1
                    var classRoom: String = "NOT_SET"
                    var roomSize: Int = -1
                    var type: String = "NOT_SET"
                    var occupied: Bool = false
                    for (key,val) in obj {
                        
                        
                        let keyString = key as! String
                        if (keyString == "datum") {
                            date = val as! String
                        }
                        if (keyString == "lesuur") {
                            collegeHour = val as! Int
                        }
                        if (keyString == "ruimte") {
                            classRoom = val as! String
                        }
                        if (keyString == "grootte") {
                            if (val is NSNull) {
                                
                            } else {
                                roomSize = val as! Int
                            }
                            
                        }
                        if (keyString == "type") {
                            if (val is NSNull) {
                                
                            } else {
                                type = val as! String
                            }
                            
                        }
                        if (keyString == "bezet") {
                            let value = val as! Int
                            if value == 0 {
                                occupied = false
                            } else {
                                occupied = true
                            }
                        }
                    }
                    var entry: RoomEntry = RoomEntry()
                    entry.classRoom = classRoom;
                    entry.date = date
                    entry.collegeHour = collegeHour
                    entry.type = type
                    entry.occupied = occupied
                    entry.roomSize = roomSize
                    
                    if self.myData[date] == nil {
                        self.myData[date] = Dictionary<String, Array<RoomEntry>>()
                    }
                    
                    if self.myData[date]![classRoom] == nil {
                        self.myData[date]![classRoom] = Array<RoomEntry>();
                    }
                    self.myData[date]![classRoom]!.append(entry)
                }
                self.fillSpinners()
                self.showData()
            }, failure: {(error:NSError!) -> Void in
                println(error)
        })
    }
    
    func showData() {
        items.removeAll()
        
        var currentDate: String = "NOT_SET"
        var currentRoom: String = "NOT_SET"
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let selectedDatePrefNotNill = defaults.objectForKey("selectedDatePref") as? String {
            currentDate = defaults.objectForKey("selectedDatePref") as! String
        }
        
        if let selectedRoomPrefNotNill = defaults.objectForKey("selectedRoomPref") as? String {
            currentRoom = defaults.objectForKey("selectedRoomPref") as! String
        }
        
        for roomEntry: RoomEntry in self.myData[currentDate]![currentRoom]! {
            let ocString = roomEntry.occupied ? "BEZET" : "VRIJ"
            self.items.append((roomEntry.getTime(), ocString))
        }
        self.tableView.reloadData()
    }
    
    func fillSpinners() {
        self.datePickerView.reloadAllComponents()
        self.datePickerView.selectRow(0,inComponent: 0,animated: false)
        self.roomPickerView.reloadAllComponents()
        self.roomPickerView.selectRow(0,inComponent: 0,animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return myData.keys.array.count
        }
        if pickerView.tag == 1 {
            if (myData[selectedDate] == nil) {
                return 0
            }
            return myData[selectedDate]!.keys.array.count
        }
        return myData.keys.array.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 0 {
            setMySelectedDate(myData.keys.array[row])
            return myData.keys.array[row]
        }
        
        if pickerView.tag == 1 {
            setMySelectedRoom(myData[selectedDate]!.keys.array[row])
            return myData[selectedDate]!.keys.array[row]
        }
        return myData.keys.array[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            setMySelectedDate(myData.keys.array[row])
        }
        if pickerView.tag == 1 {
            setMySelectedRoom(myData[selectedDate]!.keys.array[row])
        }
        showData()
    }
    
    func setMySelectedDate(date: String) {
        self.selectedDate = date
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(date, forKey: "selectedDatePref")
        defaults.synchronize()
    }
    
    func setMySelectedRoom(room: String) {
        self.selectedRoom = room
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(room, forKey: "selectedRoomPref")
        defaults.synchronize()
    }
    
    
}

