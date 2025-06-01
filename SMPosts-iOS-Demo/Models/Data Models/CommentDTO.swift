//
//  CommentDTO.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct CommentDTO: Cachable {
    
    // MARK: - Properties
    
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
    
    // MARK: - Getters
    
    static var cacheKey: String {
        CacheService.Keys.commentsDTO
    }
}
