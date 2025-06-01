//
//  PostDTO.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct PostDTO: Cachable {
    
    // MARK: - Properties
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
    // MARK: - Getters
    
    static var cacheKey: String {
        CacheService.Keys.postsDTO
    }
}
