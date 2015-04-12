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

class ViewController: UIViewController{
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate //to retrieve oauth
    var myData = Dictionary<String, Dictionary<String, Array<RoomEntry>>>()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func testMethod(sender: AnyObject) {
        fireMethod()
    }
    var items: [(String,String,String)] = [
        ("Pim", "Verlangen", "08:45 - 09:20"),
        ("Gijs", "VdVenne", "09:25 - 10:10"),
        ("Daniel", "Eijkelenboom", "10:15 - 11:00")
    ]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:EntryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! EntryTableViewCell
        
        // this is how you extract values from a tuple
        var (fn,ln,id) = items[indexPath.row]
        
        cell.loadItem(time: id, status: fn)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        parameters["start"] = "2015-03-05"
        parameters["end"] = "2015-03-05"
        parameters["filter"] = "OB207"
        parameters["type"] = "all"
        delegate.oauthswift.client.get("https://publicapi.avans.nl/oauth/lokaalbeschikbaarheid/", parameters: parameters,
            success: {
                data, response in
                let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                //println(jsonDict)
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
                            roomSize = val as! Int
                        }
                        if (keyString == "type") {
                            type = val as! String
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
                    let ocString = occupied ? "BEZET" : "VRIJ"
                    self.items.append(ocString,"nee", String(collegeHour))
                    self.myData[date]![classRoom]!.append(entry)
                }
                println(self.myData)
                self.tableView.reloadData()
            }, failure: {(error:NSError!) -> Void in
                println(error)
        })
    }
    
    


}

