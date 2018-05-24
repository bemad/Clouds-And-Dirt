//
//  MainViewController.swift
//  fifthApp
//
//  Created by Bhavya Madan on 01/03/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//
import UIKit
import MapKit
import CoreData
class MainViewController: UIViewController, NSFetchedResultsControllerDelegate,MKMapViewDelegate {
    let segueIdentifierString = "CollectionViewS"
    var canBeDeleted = false
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let makeReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        do {
            if let fetched = try CoreDataObject.shared.context.fetch(makeReq) as? [Pin] {
                for pin in fetched {
                    let point = MKPointAnnotation()
                    point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.lat),longitude: CLLocationDegrees(pin.lon))
                    map.addAnnotation(point)
                }
            }
        } catch {
            print("o.o No Pins Found o.o ")
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view.animatesDrop = true
        }
        return view
    }
    //https://stackoverflow.com/a/42635059/8689882 was not so relevant but gave the hint
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if let viewAnotation = view.annotation {
            let makeReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
            //https://www.hackingwithswift.com/read/38/7/examples-of-using-nspredicate-to-filter-nsfetchrequest
            let tempPredi = NSPredicate(format: "lat == %@ AND lon == %@", argumentArray: [viewAnotation.coordinate.latitude, viewAnotation.coordinate.longitude])
            makeReq.predicate = tempPredi
            do {
                if let result = try CoreDataObject.shared.context.fetch(makeReq) as? [Pin], let pin = result.first {
                    if canBeDeleted {
                        print("DELETE PIN")
                        CoreDataObject.shared.context.delete(pin)
                        CoreDataObject.shared.save()
                        mapView.removeAnnotation(viewAnotation)
                    } else {
                        print("Opening collection view")
                        performSegue(withIdentifier: segueIdentifierString, sender: pin)
                    }
                }
            } catch {
                print("No Pins")
            }
        }
    }
    //https://stackoverflow.com/a/29466391/8689882
    @IBAction func newPin(_ tap: UILongPressGestureRecognizer) {
        if tap.state == .began {
            let position = map.convert(tap.location(in: map), toCoordinateFrom: map)
            let point = Pin(context: CoreDataObject.shared.context)
            point.lat = Double(position.latitude)
            point.lon = Double(position.longitude)
            //add to db
            CoreDataObject.shared.save()
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = position
            map.addAnnotation(pointAnnotation)
        }
    }
    
    @IBAction func alternateDelete(_ sender: UIBarButtonItem) {
        if(canBeDeleted){
            editButton.title = "Edit"
        }
        else{
            editButton.title = "Done"
        }
        canBeDeleted = !canBeDeleted
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueIdentifierString {
            let CVC = segue.destination as! CollectionViewController
            CVC.pin = sender as! Pin
        }
    }
}
