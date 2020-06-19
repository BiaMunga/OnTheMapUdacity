//
//  StudentLocationDetails.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 17/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationDetails: Codable {
   let createdAt: String
   let firstName: String
   let lastName: String
   let latitude: Double
   let longitude: Double
   let mapString: String
   let mediaURL: String
   let objectId: String
   let uniqueKey: String
   let updatedAt: String
   }
