//
//  PublicDataRequest.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 16/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
struct PublicDataRequest: Codable {

        let lastName: String
        let firstName: String
        let key: String
        
        
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key = "key"
    }
}
