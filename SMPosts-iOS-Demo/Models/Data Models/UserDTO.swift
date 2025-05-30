//
//  UserDTO.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct UserDTO: Decodable {
    
    // MARK: - Structs
    
    struct Address: Decodable {
        
        // Structs
        struct Geo: Decodable {
            let lat: Double
            let lng: Double
        }
        
        // Properties
        let street: String
        let suite: String
        let city: String
        let zipcode: String
    }
    
    struct Company: Decodable {
        
        let name: String
        let catchPhrase: String
        let bs: String
    }
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
