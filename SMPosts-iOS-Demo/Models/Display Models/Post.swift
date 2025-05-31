//
//  Post.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation
import SwiftUI


struct Post: Identifiable {
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let content: String
    let authorEmail: String
    let comments: [Comment]
    
    // Images can either be loaded from an URL
    let thumbnailImageURL: URL?
    let detailImageURL: URL?

    // Or loaded locally when a post is created
    let thumbnailImage: Image?
    let detailImage: Image?
    
    // MARK: - Life cycle
    
    init(id: Int,
         title: String,
         content: String,
         authorEmail: String,
         comments: [Comment],
         thumbnailImageURL: URL?,
         detailImageURL: URL?,
         thumbnailImage: Image?,
         detailImage: Image?
    ) {
        self.id = id
        self.title = title.capitalizedFirstLetter()
        self.content = content.capitalizedFirstLetter()
        self.authorEmail = authorEmail.lowercased()
        self.comments = comments
        self.thumbnailImageURL = thumbnailImageURL
        self.detailImageURL = detailImageURL
        self.thumbnailImage = thumbnailImage
        self.detailImage = detailImage
    }
}
