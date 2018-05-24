//
//  ViewController.swift
//  OnTheMap
//
//  Created by Bhavya Madan on 05/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var annotations = [MKPointAnnotation]()
    var indicator = Indicator()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let locations = hardCodedLocationData()
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadMapView()
        indicator.loadingView(true)
    }
    @IBAction func insertLocation(_ sender: Any) {
        UN.sharedInstance().addLocation(self)
    }
    @IBAction func logout(_ sender: Any) {
        UN.sharedInstance().logoutID(controller: self)
        
        dismiss(animated: true, completion: {
            UN.sharedInstance().logoutID(controller: self)
        })
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        indicator.loadingView(true)
        
        loadMapView()
    }
    func loadMap() {
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        
        for dictionary in UsersInfo.UsersArray {
            let lat = dictionary.lat
            let long = dictionary.long
            //unwrap?
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
    
    
    func loadMapView() {
        UN.sharedInstance().getUsersData() {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.loadMap()
                    self.indicator.loadingView(false)
                }
                
            } else {
                
                self.indicator.stopAnimating()
                UN.sharedInstance().alertError(self, error: self.appDelegate.errorMessage.DataError)
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView=UIButton(type: .infoDark)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if UN.sharedInstance().checkURL(toOpen){
                    app.openURL(URL(string: toOpen)!)
                } else {
                    UN.sharedInstance().alertError(self, error: self.appDelegate.errorMessage.InvalidLink)
                }
            }
        }
    }
    
    func canOpenURL(url: URL) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    
}

