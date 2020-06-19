//
//  StudentLocationPostRequest.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 16/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationPostRequest: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
