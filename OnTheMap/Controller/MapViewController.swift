//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 11/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let pinNewSegue = "pinFromMap"
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPin: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStudentLocations()
    }
     
    @IBAction func pinTapped(_ sender: UIBarButtonItem) {
            
         self.performSegue(withIdentifier: self.pinNewSegue, sender: self)
       }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }

    func loadStudentLocations() {
    OnTheMapClient.getStudentLocation(completion: { (students, error) in
    if let error = error {
        print(error)
        }
        else {
        DispatchQueue.main.async {
            self.updateMap(students: students)
        }
        }
        })
    }
    
    func updateMap(students: [StudentLocationDetails]) {
        mapView.removeAnnotations(mapView.annotations)
        StudentLocationsModel.studentLocations = students
        for student in students { 
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate =
                CLLocationCoordinate2DMake(CLLocationDegrees(student.latitude), CLLocationDegrees(student.longitude))
            pointAnnotation.title = student.firstName
            pointAnnotation.subtitle = student.mediaURL
            self.mapView.addAnnotation(pointAnnotation)
        }
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
     
    

}
