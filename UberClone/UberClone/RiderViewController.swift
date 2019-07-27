//
//  RiderViewController.swift
//  UberClone
//
//  Created by Quang Kha Tran on 24/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callAnUberButton: UIButton!
    
    var locationManger = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled: Bool = false
    var driverOnTheWay: Bool = false
    
    @IBAction func callUberTapped(_ sender: Any) {
        if !driverOnTheWay {
            if let email = FIRAuth.auth()?.currentUser?.email {
                if uberHasBeenCalled {
                    
                    FIRDatabase.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                        snapshot.ref.removeValue()
                        FIRDatabase.database().reference().child("RideRequests").removeAllObservers()
                    }
                    uberHasBeenCalled = false
                    callAnUberButton.setTitle("Call an Uber", for: .normal)
                    
                } else {
                    
                    let rideRequestDictionary:[String:Any] = [ "email":email, "lat":userLocation.latitude, "lon":userLocation.longitude ]
                    FIRDatabase.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                    uberHasBeenCalled = true
                    callAnUberButton.setTitle("Cancel Uber", for: .normal)
                    
                }
            }
        }
    }
    
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        if let email = FIRAuth.auth()?.currentUser?.email {
            FIRDatabase.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                self.uberHasBeenCalled = true
                self.callAnUberButton.setTitle("Cancel Uber", for: .normal)
                FIRDatabase.database().reference().child("RideRequests").removeAllObservers()
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                        if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                            self.driverOnTheWay = true
                            self.displayDriverAndRider()
                            
                            let email = FIRAuth.auth()?.currentUser?.email
                            FIRDatabase.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with:
                                { (snapshot) in
                                    if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                                        if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                                            if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                                                self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                                                self.driverOnTheWay = true
                                                self.displayDriverAndRider()
                                            }
                                        }
                                    }
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    func displayDriverAndRider(){
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
        let roundedDistance = round(distance*100)/100
        callAnUberButton.setTitle("Your driver is \(roundedDistance)km away", for: .normal)
        map.removeAnnotations(map.annotations)
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005
        let lonDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        map.setRegion(region, animated: true)
        
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = userLocation
        riderAnnotation.title = "Your Location"
        map.addAnnotation(riderAnnotation)
        
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = driverLocation
        driverAnnotation.title = "Your Driver"
        map.addAnnotation(driverAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations[0])
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            
            if uberHasBeenCalled {
                displayDriverAndRider()
                
            } else {
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                map.setRegion(region, animated: true)
                map.removeAnnotations(map.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "Your location"
                map.addAnnotation(annotation)
            }
        }
        
    }
    
    
    
}
