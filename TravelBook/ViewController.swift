//
//  ViewController.swift
//  TravelBook
//
//  Created by Enes Kaya on 12.07.2022.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapKit: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

        // Do any additional setup after loading the view.
    
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude:locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        let span     = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region   = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
    


}

