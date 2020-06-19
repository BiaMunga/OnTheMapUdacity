//
//  DetailedViewController.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 11/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {
    
    let mapPreviewID = "findOnMap"
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var findOnMap: UIButton!
    
     override func viewDidLoad() {
            super.viewDidLoad()

            locationInput.delegate = self
        }
            
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
         
      self.performSegue(withIdentifier: self.mapPreviewID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapPreviewID {
        // Create a variable that you want to send

        let vc = segue.destination as! PreviewViewController
            vc.mapString = locationInput.text!
        }
    }

}
 
