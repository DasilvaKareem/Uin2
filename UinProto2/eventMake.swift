//
//  eventMake.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit


class eventMake: UIViewController, UITextFieldDelegate {
    var dateTime = String()
    var dateStr = String()
    var orderDate = NSDate()
    var endDate = NSDate()
    var startTime = String()
    var endTime = String()
    var eventTitlePass = (String)()
    var eventLocation = (String)()
    var eventID = (String)()
    var userId = (String)()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    

    
    @IBOutlet var oncampusSegement: UISegmentedControl!
    @IBOutlet var freeSegment: UISegmentedControl!
    @IBOutlet var foodSegement: UISegmentedControl!
    @IBOutlet var publicSegment: UISegmentedControl!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventSum: UITextField!
    @IBAction func startAction(sender: AnyObject) {
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
    
    @IBAction func endAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
    @IBOutlet var start: UIButton!
    @IBOutlet var onCampus: UISegmentedControl!
    @IBOutlet var end: UIButton!
    var eventPublic:Bool = true
    var onsite:Bool = true
    var food:Bool = true
    var paid:Bool = true
    
    @IBAction func publicEvent(sender: UISegmentedControl) {
        
        println(eventPublic)
        switch sender.selectedSegmentIndex {
        case 0:
            eventPublic = true
        case 1:
            eventPublic = false
            
        default:
            eventPublic = true
            break;
        }  //Switch
    }
    
    @IBAction func location(sender: UISegmentedControl) {
        println(onsite)
        switch sender.selectedSegmentIndex {
        case 0:
            onsite = true
        case 1:
            onsite = false
            
        default:
            onsite = true
            break;
        }  //Switch
        
    }
    
    @IBAction func isFood(sender: UISegmentedControl) {
        println(food)
        switch sender.selectedSegmentIndex {
        case 0:
            food = true
        case 1:
            food = false
            
        default:
            food = true
            break;
        }  //Switch
    }
    
    @IBAction func isPaid(sender: UISegmentedControl) {
        println(paid)
        switch sender.selectedSegmentIndex {
        case 0:
            paid = true
        case 1:
            paid = false
            
        default:
            paid = true
            break;
        }  //Switch
        
    }
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    // Creates the event and adds to the calendar
    
    @IBAction func makeEvent(sender: AnyObject) {
        
        var userFollowers = [String]()
        var allError = ""
        
        if eventTitle.text == "" {
            
            allError = "Enter a Title for your Event"
            println(allError)
            
        }
        
        if eventSum.text == ""{
            
            allError = "Enter a location for your Event"
            println(allError)
        }
        
        if dateTime1 == "" {
            
            allError = "Enter a Start Time"
            
        }
        
        if dateTime2 == ""{
            allError = "Enter a End Time"
        }
        println(allError)

        if allError == "" {
            //If the user is editing the event
            if editing == true {
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        
                        eventItem["start"] = orderDate1
                        eventItem["end"] = orderDate2
                        eventItem["isPublic"] = self.eventPublic
                        eventItem["hasFood"] = self.food
                        eventItem["isFree"] = self.paid
                        eventItem["onCampus"] = self.onsite
                        eventItem["location"] = self.eventSum.text
                        eventItem["title"] = self.eventTitle.text
                        eventItem["author"] = PFUser.currentUser().username
                        eventItem["authorID"] = PFUser.currentUser().objectId
                        eventItem["isDeleted"] = false
                        eventItem.saveInBackgroundWithBlock({
                            (success:Bool!, error:NSError!) -> Void in
                            
                            if error == nil {
                                orderDate1 = NSDate()
                                orderDate2 = NSDate()
                                dateTime1 = String()
                                dateTime2 = String()
                                dateStr1 = String()
                                dateStr2 = String()
                                startString = String()
                                endString = String()
                          
                            }
                                self.performSegueWithIdentifier("eventback", sender: self)
                        })
                        var push =  PFPush()
                        let data = [
                            "alert" : "\(PFUser.currentUser().username) has edited the event '\(self.eventTitle.text)'",
                            "badge" : "Increment",
                            "sound" : "default"
                        ]
                        push.setChannel(PFUser.currentUser().objectId)
                        push.setData(data)
                        push.sendPushInBackgroundWithBlock({
                            
                            (success: Bool!, pushError: NSError!) -> Void in
                            if pushError == nil {
                                println("the push was sent")
                            }
                            var theMix = Mixpanel.sharedInstance()
                            theMix.track("Edited Event")
                        })
                    }
                })
            }
            else {
                var event = PFObject(className: "Event")
                event["start"] = orderDate1
                event["end"] = orderDate2
                event["isPublic"] = self.eventPublic
                event["hasFood"] = self.food
                event["isFree"] = self.paid
                event["onCampus"] = self.onsite
                event["location"] = self.eventSum.text
                event["title"] = self.eventTitle.text
                event["author"] = PFUser.currentUser().username
                event["authorID"] = PFUser.currentUser().objectId
                event["isDeleted"] = false
                event.saveInBackgroundWithBlock{
                    
                    (success:Bool!,eventError:NSError!) -> Void in
                    
                    if (eventError == nil){
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has created an event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            push.setChannel(PFUser.currentUser().objectId)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                            
                                (success: Bool!, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    
                                    println("the push was sent")
                                    
                                }
                                
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Edited Event")
                                
                            })

                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Created an Event")
                        var notify = PFObject(className: "Notification")
                        notify["senderID"] = PFUser.currentUser().objectId
                        notify["receiverID"] = PFUser.currentUser().objectId
                        notify["sender"] = PFUser.currentUser().username
                        notify["receiver"] = PFUser.currentUser().username
                        notify["type"] =  "event"
                        notify.saveInBackgroundWithBlock({
                            (success:Bool!, notifyError: NSError!) -> Void in
                            if notifyError == nil {
                                println("notifcation has been saved")
                            }
                            else {
                                println("fail")
                            }
                        })
                        orderDate1 = NSDate()
                        orderDate2 = NSDate()
                        dateTime1 = String()
                        dateTime2 = String()
                        dateStr1 = String()
                        dateStr2 = String()
                        startString = String()
                        endString = String()
                        self.performSegueWithIdentifier("eventback", sender: self)
                        println("it worked")
                        
                    }
                }
            }
        }
        else {
            displayAlert("Error", error: allError)
        }
    }
    
    @IBAction func deleteEvent(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Are you sure", message: "Do you want to delete this event", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
            switch action.style{
            case .Destructive:
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(self.eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Deleted event")
                        var name = PFUser.currentUser().username
                        eventItem["isDeleted"] = true
                        eventItem.save()
                        let data = [
                            "alert" : "\(PFUser.currentUser().username) has deleted the event '\(self.eventTitle.text)'",
                            "badge" : "Increment",
                            "sound" : "default"
                        ]
                            var push =  PFPush()
                            push.setChannel(PFUser.currentUser().objectId)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                                
                                (success: Bool!, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    
                                    println("the push was sent")
                                    
                                }

                            })
                        self.performSegueWithIdentifier("eventback", sender: self)
                        
                    }
                })
            case .Cancel:
                println("cancel")
                
            case .Default:
                println("destructive")
            }
        }))
        
    }
    override func viewDidAppear(animated: Bool) {
        
        if (startString == ""){
            start.setTitle("Start Time", forState: UIControlState.Normal)
        }
        else {
            start.setTitle(startString, forState: UIControlState.Normal)
        }
        if (endString == "") {
            end.setTitle("End Time", forState: UIControlState.Normal)
        }
        else {
            end.setTitle(endString, forState: UIControlState.Normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        if editing == false {
            
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            eventTitle.text = eventTitlePass
            eventSum.text = eventLocation
        }
        println("This is a print of the BOOLS")
        println(onsite)
        println(food)
        println(paid)
        if food == true {
            println("OK IT WOKRS")
            foodSegement.selectedSegmentIndex = 0
        }
        else {
            println("FOOD IS NOT TRUE")
            foodSegement.selectedSegmentIndex = 1
        }
        if paid == true {
            println("OK IT WOKRS")
            freeSegment.selectedSegmentIndex = 0
        }
        else {
            println("PAID IS NOT TRUE")
            freeSegment.selectedSegmentIndex = 1
        }
        if onsite == true {
            println("OK IT WOKRS")
            oncampusSegement.selectedSegmentIndex = 0
        }
        else {
            println("ONSITE is true")
            oncampusSegement.selectedSegmentIndex = 1
        }
        if PFUser.currentUser() == nil{
            
            self.performSegueWithIdentifier("register", sender: self)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
