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
                
            if lat != nil {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate =
                CLLocationCoordinate2DMake(CLLocationDegrees(self.latitude), CLLocationDegrees(self.longitude))
            self.mapView.addAnnotation(pointAnnotation)
                } else {
                self.showLinkFailure(message: "Location not found. Please go back and enter in format: City, Country")
                }
    }
        }
            
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    }
    
    @IBAction func submitPin(_ sender: UIButton) {
        let link = linkInput.text!
        if link.isValidURL {
            self.postLocation(link: link)
        } else {
            self.showLinkFailure(message: "Please make sure the link is in the correct format (https://www.)")
        }
    }
    
    func postLocation(link: String) {
        OnTheMapClient.postStudentLocation(latitude: self.latitude, longitude: self.longitude, mapString: self.mapString, mediaURL: link, completion: self.handlePostResponse(success:error:))
}
    
    func handlePostResponse(success: Bool, error: Error?) {
    if success {
        self.performSegue(withIdentifier: self.pinSubmitID, sender: self)
        }
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == pinSubmitID {
                _ = segue.destination as! UITabBarController
            }
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "https://www."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
          }
        
        func showLinkFailure(message: String) {
            let alertVC = UIAlertController(title: "Pin Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }

}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
