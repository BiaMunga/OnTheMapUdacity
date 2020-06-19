//
//  LoginSessionDelete.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 13/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginSessionDelete: Codable {
    let session: Session
    
    struct Session: Codable {
        let id: String
        let expiration: String
    }
}
