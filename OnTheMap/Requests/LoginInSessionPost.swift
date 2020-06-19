//
//  LoginInSessionPost.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 13/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
struct LoginSessionPost: Codable {
    let account: Account
    let session: Session
    
    struct Account: Codable {
        let registered: Bool
        let key: String
    }
    
    
    
    struct Session: Codable {
        let id: String
        let expiration: String
    }
}
