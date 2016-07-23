//
//  ViewController.swift
//  Favourite Places
//
//  Created by Gagandeep Nagpal on 22/07/16.
//  Copyright © 2016 Gagandeep Nagpal. All rights reserved.
//

import UIKit

var places = [Dictionary <String,String>()]

var myPlace = -1

class ViewController: UIViewController,UITableViewDelegate {

    @IBOutlet var list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if places.count == 1 {
            
            places.removeAtIndex(0)
            
            places.append(["name":"Eiffel Tower","lat":"48.8583°","lon":"2.2945°"])
            
        }
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("places") != nil {
            
            
            places = NSUserDefaults.standardUserDefaults().objectForKey("places") as! [Dictionary]
            
        }


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
       return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text =  "\(places[indexPath.row]["name"]!)"
        
        return cell

    }
    
    //THIS RETURNS THE ROW I.E. THE LOCATION WANTS TO SEE ON THE MAP. IT US SET TO MYPLACE
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        myPlace = indexPath.row
        
        return indexPath
        
    }
    
    
    //TO MAKE SURE THE MAP OPENS ON THE USERS LOCATION WHEN THE USER PRESSES THE + BUTTON
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddLocation" {
            
            myPlace = -1
            
        }
        
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            places.removeAtIndex(indexPath.row)
            
            //TO STORE DATA
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            
            list.reloadData()
        }
        
        
    }


    override func viewDidAppear(animated: Bool) {
        
        list.reloadData()
        
    }

 
    



}

