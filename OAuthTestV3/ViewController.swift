//
//  ViewController.swift
//  OAuthTestV3
//
//  Created by User on 11/04/15.
//  Copyright (c) 2015 Avans. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController{
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate //to retrieve oauth
    @IBAction func testMethod(sender: AnyObject) {
        fireMethod()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                    for (key,val) in obj {
                        let keyString = key as! String
                        if (keyString == "datum") {
                            let valString = val as! String
                            println(valString)
                        }
                    }
                }
            }, failure: {(error:NSError!) -> Void in
                println(error)
        })
    }
    
    


}

