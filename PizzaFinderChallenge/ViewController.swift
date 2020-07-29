//
//  ViewController.swift
//  MapKitChallenge
//
//  Created by BYNC on 7/29/20.
//  Copyright © 2020 AliDarawsha. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation{
    var imageName: String!
}


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userLocation.title = "My Location"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            //currentlocation = location
            if (count == 0){
                setCenterOfMapToLocation(location: location)
                count += 1
            }
        }
        
        
    }
    
    func setCenterOfMapToLocation(location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    @IBAction func onButtonPress(_ sender: UIButton) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Pizza"
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start{ (response,error) in
            if let response = response{
                for mapItem in response.mapItems{
                    
                    let annotation = CustomPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }

        let reuseId = "test"
    
        var resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            
            // Resize
            let pinImage = UIImage(named: "Pizza.png")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()

            anView?.image = resizedImage

            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            anView?.rightCalloutAccessoryView = rightButton as? UIView
            
        }
            
        else {
            anView!.annotation = annotation
        }

        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        anView!.image = resizedImage

        return anView
    }
    
    
    
}

