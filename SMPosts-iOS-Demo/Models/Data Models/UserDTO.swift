//
//  UserDTO.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct UserDTO: Cachable {
    
    // MARK: - Structs
    
    struct Address: Codable {
        
        // Structs
        struct Geo: Codable {
            let lat: Double
            let lng: Double
        }
        
        // Properties
        let street: String
        let suite: String
        let city: String
        let zipcode: String
    }
    
    struct Company: Codable {
        
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
    
    // MARK: - Getters
    
    static var cacheKey: String {
        CacheService.Keys.usersDTO
    }
}
