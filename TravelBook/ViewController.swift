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
    
    var selectedTitle = ""
    var selectedTitleID : UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLongitude = Double()
    var annotationLatitude = Double()
    
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gesterRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gesterRecognizer:)))
        gesterRecognizer.minimumPressDuration = 2
        mapKit.addGestureRecognizer(gesterRecognizer)

        // Do any additional setup after loading the view.
        
        if selectedTitle != ""{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            let idString = selectedTitleID!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results =  try context.fetch(fetchRequest)
               
                if results.count > 0{
                    for result in results  as! [NSManagedObject]{
                        if let title = result.value(forKey: "title") as? String{
                            annotationTitle = title
                            if let subtitle = result.value(forKey: "subtitle") as? String{
                                annotationSubtitle = subtitle
                                if let longitude = result.value(forKey: "longitude") as? Double{
                                    annotationLongitude = longitude
                                    if let latitude = result.value(forKey: "latitude") as? Double{
                                        annotationLatitude = latitude
                                        
                                        let annotation = MKPointAnnotation()
                                        annotation.title = annotationTitle
                                        annotation.subtitle = annotationSubtitle
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                        annotation.coordinate = coordinate
                                        
                                        mapKit.addAnnotation(annotation)
                                        nameText.text = annotationTitle
                                        commentText.text = annotationSubtitle
                                        
                                        
                                        locationManager.stopUpdatingLocation()
                                        let span     = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                        let region   = MKCoordinateRegion(center: coordinate, span: span)
                                        mapKit.setRegion(region, animated: true)
                                        
                                        
                                }
                            }
                        }
                        
                        
                       
                          
                        }
                    }
                    
                }
            }
                catch{
                    print("fail")
                }
            }
        else{
            
        }
    
    
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
            
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        <#code#>
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
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigationController?.popViewController(animated: true)
        
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedTitle == ""{
        let location = CLLocationCoordinate2D(latitude:locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        let span     = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region   = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
        }
        else{
            
        }
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

