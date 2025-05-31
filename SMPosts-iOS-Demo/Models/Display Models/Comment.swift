//
//  Comment.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct Comment: Identifiable {
    
    // MARK: - Properties
    
    var id: Int
    var authorEmail: String
    var content: String
    
    // MARK: Life cycle
    
    init(commentDTO: CommentDTO) {
        id = commentDTO.id
        authorEmail = commentDTO.email.lowercased()
        content = commentDTO.body.capitalizedFirstLetter()
    }
}
