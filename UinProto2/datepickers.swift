//
//  datepickers.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

var dateTime1 = String()
var dateStr1 = String()
var orderDate1 = NSDate()
var dateTime2 = String()
var dateStr2 = String()
var orderDate2 = NSDate()
var startString = String()
var endString = String()
class datepickers: UIViewController {
    
    @IBOutlet var startTIme: UILabel!
    @IBOutlet var endTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var datepicker1: UIDatePicker!
    @IBAction func theDatePicker(sender: AnyObject) {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateStr1 = dateFormatter.stringFromDate(datepicker1.date)
      
        let dateTimeformat = NSDateFormatter()
       dateTimeformat.timeStyle = NSDateFormatterStyle.ShortStyle
        dateTime1 =  dateTimeformat.stringFromDate(datepicker1.date)
        orderDate1 = datepicker1.date
        startString = dateStr1 + " " + dateTime1
        startTIme.text = startString
        
       
    }
    
    @IBOutlet var datepicker2: UIDatePicker!
    @IBAction func thesecondDate(sender: AnyObject) {
        
       
        //startTIme.text = endString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateTimeformat = NSDateFormatter()
        dateTimeformat.timeStyle = NSDateFormatterStyle.ShortStyle
        dateTime2 = dateTimeformat.stringFromDate(datepicker2.date)
        dateStr2 = dateFormatter.stringFromDate(datepicker2.date)
        orderDate2 = datepicker2.date
        endString = dateStr2 + " " + dateTime2
        endTime.text = endString
    }
}
