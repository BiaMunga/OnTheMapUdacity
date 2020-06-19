//
//  PublicDataRequest.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 16/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
struct PublicDataRequest: Codable {
    let user: Details
    
    struct Details: Codable {
        let firstName: String
        let lastName: String
        
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    }
}
