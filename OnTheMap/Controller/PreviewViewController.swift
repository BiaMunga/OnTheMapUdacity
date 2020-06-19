//
//  PreviewViewController.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 17/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PreviewViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
  
    var mapString: String!
    var latitude: Double!
    var longitude: Double!
    
    let pinSubmitID = "pinSubmit"
    
    @IBOutlet weak var linkInput: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
   override func viewDidLoad() {
            super.viewDidLoad()

            linkInput.delegate = self
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(mapString) { (placemarks, error) in
            let placemark = placemarks?[0]
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            self.latitude = lat
            self.longitude = lon
                
            print("Lat: \(lat), Lon: \(lon)")
                
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate =
                CLLocationCoordinate2DMake(CLLocationDegrees(self.latitude), CLLocationDegrees(self.longitude))
            self.mapView.addAnnotation(pointAnnotation)
    }
        }
            
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    }
    
    @IBAction func submitPin(_ sender: UIButton) {
        let link = linkInput.text!
        OnTheMapClient.postStudentLocation(latitude: self.latitude, longitude: self.longitude, mapString: self.mapString, mediaURL: link, completion: self.handlePostResponse(success:error:))
    }
    
    func handlePostResponse(success: Bool, error: Error?) {
    if success {
        self.performSegue(withIdentifier: self.pinSubmitID, sender: self)
        }
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == pinSubmitID {
            // Create a variable that you want to send

                _ = segue.destination as! UITabBarController
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
          }

}
