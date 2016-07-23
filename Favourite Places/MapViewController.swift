//
//  MapViewController.swift
//  Favourite Places
//
//  Created by Gagandeep Nagpal on 23/07/16.
//  Copyright © 2016 Gagandeep Nagpal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    
    var manager :CLLocationManager!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //WHEN THE USER PRESSES ON THE + BUTTON IN THE APP
        if(myPlace == -1) {
            
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
            
        }
        
            //WHEN THE USER PRESSES ON A LOCATION ALREADY ADDED I.E. myPlace HAS A SPECIFIC VALUE THAT THE USER HAS PRESSED.
        else{
            
            let latitude = NSString(string: places[myPlace]["lat"]!).doubleValue
            
            let longitude = NSString(string: places[myPlace]["lon"]!).doubleValue
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let latDelta:CLLocationDegrees = 0.01
            
            let lonDelta:CLLocationDegrees = 0.01
            
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            
            annotation.title = places[myPlace]["name"]
            
            self.map.addAnnotation(annotation)
            
            
            
            
            
        }
        
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.action(_:)))
        
        uilpgr.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(uilpgr)

        
        
        
    }

    //THIS FUNCTION IS USED TO GET THE USERS LOCATION
    func locationManager(manager : CLLocationManager, didUpdateLocations locations:[CLLocation]){
        
        
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "My Location"
        
        map.addAnnotation(annotation)
        
        
        
        

    }
    
    
    //NEW ANNOTATION IS BEING ADDED
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        
        //TO ENSURE THAT MORE THAN ONE ANNOTION IS NOT PLACED AT A TIME (IF STATEMENT)
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                
                var title = ""
                
                if (error == nil) {
                    
                    if let p = placemarks?[0] {
                        
                        
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                            
                            subThoroughfare = p.subThoroughfare!
                            
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare!
                            
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                        
                        
                    }
                    
                }
                
                //TO CHECK IF TITLE IS EMPTY,IF SO,ADD DATE
                
                
                if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")

                
            })
            
            
            
        }
        
        
    }

   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
