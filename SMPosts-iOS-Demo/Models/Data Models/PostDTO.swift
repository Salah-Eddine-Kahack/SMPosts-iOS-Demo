//
//  PostDTO.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct PostDTO: Decodable {
    
    // MARK: - Properties
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
