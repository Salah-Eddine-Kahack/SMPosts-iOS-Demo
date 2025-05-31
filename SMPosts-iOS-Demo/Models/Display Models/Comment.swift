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
    
    /// Only used for mocking purposes
    fileprivate init(id: Int,
                     authorEmail: String,
                     content: String)
    {
        self.id = id
        self.authorEmail = authorEmail
        self.content = content
    }
}

// MARK: - Mock

extension Comment {
    
    static var mock1: Comment {
        Comment(
            id: 1,
            authorEmail: "john@doe.com",
            content: "Nice setup dude ! Where did you get that iPad stand ?"
        )
    }
    
    static var mock2: Comment {
        Comment(
            id: 2,
            authorEmail: "jane@doe.com",
            content: "Oh My God ! I love the color combination !\n Yeah, I want a similar iPad stand too !"
        )
    }
    
    static var mock3: Comment {
        Comment(
            id: 3,
            authorEmail: "typical_internet_user@gmail.com",
            content: "You call that a desk setup ? You just put all your tools on a table.\nI have a desk with a drawer for each tool. It's much more organized."
        )
    }
}
