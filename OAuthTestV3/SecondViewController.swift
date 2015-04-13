//
//  SecondViewController.swift
//  OAuthTestV3
//
//  Created by Daniel Eijkelenboom on 13/04/15.
//  Copyright (c) 2015 Avans. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var roomField: UITextField!
    @IBAction func onSaveButtonClicked(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate: String = dateFormatter.stringFromDate(startDatePicker.date)
        let endDate: String = dateFormatter.stringFromDate(endDatePicker.date)
        let rooms: String = roomField.text
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(startDate, forKey: "dateStart")
        defaults.setObject(endDate, forKey: "dateEnd")
        defaults.setObject(rooms, forKey: "rooms")
        defaults.synchronize()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func parseDate(rawDate: String) -> String {
        var rawDateArr = split(rawDate) { $0 == " " }
        return rawDateArr[0]
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
