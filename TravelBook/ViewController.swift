//
//  ViewController.swift
//  TravelBook
//
//  Created by Enes Kaya on 12.07.2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapKit: MKMapView!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gesterRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gesterRecognizer:)))
        gesterRecognizer.minimumPressDuration = 3
        mapKit.addGestureRecognizer(gesterRecognizer)

        // Do any additional setup after loading the view.
    
    
    }
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(choosenLatitude, forKey: "latitude")
        newPlace.setValue(choosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        
        do{
            try  context.save()
            print("success")
        }catch{
            print("fail")
        }
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude:locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        let span     = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region   = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
    @objc func chooseLocation(gesterRecognizer : UILongPressGestureRecognizer){
        
        if gesterRecognizer.state == .began {
            
            let touchPoint = gesterRecognizer.location(in: self.mapKit)
            let touchCoordinates = self.mapKit.convert(touchPoint, toCoordinateFrom: self.mapKit)
            
            choosenLatitude = touchCoordinates.latitude
            choosenLongitude = touchCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinates
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapKit.addAnnotation(annotation)
            
            
            
        }
        
        
        
        
    }
    
    


}

