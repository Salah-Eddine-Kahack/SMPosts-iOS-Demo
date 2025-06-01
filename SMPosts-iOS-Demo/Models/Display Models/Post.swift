//
//  Post.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


struct Post: Identifiable, Cachable {
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let content: String
    let authorEmail: String
    let comments: [Comment]
    
    let thumbnailURL: URL?
    let detailImageURL: URL?
    
    // MARK: - Getters
    
    static var cacheKey: String {
        CacheService.Keys.posts
    }
    
    // MARK: - Life cycle
    
    init(id: Int,
         title: String,
         content: String,
         authorEmail: String,
         comments: [Comment],
         thumbnailURL: URL?,
         detailImageURL: URL?
    ) {
        self.id = id
        self.title = title.capitalizedFirstLetter()
        self.content = content.capitalizedFirstLetter()
        self.authorEmail = authorEmail.lowercased()
        self.comments = comments
        self.thumbnailURL = thumbnailURL
        self.detailImageURL = detailImageURL
    }
}

// MARK: - Mock

extension Post {
    
    static var mock: Self {
        Post(
            id: 2,
            title: "Check out my new desk setup!",
            content: "I finally got my hands on a new desk and I spent the whole day setting it up! I love how modern and sleek it is. What do you think? #DeskLife #NewDesk",
            authorEmail: "rachel@example.com",
            comments: [
                Comment.mock1,
                Comment.mock2,
                Comment.mock3
            ],
            thumbnailURL: PostService.makeThumbnailImageURL(seed: 2),
            detailImageURL: PostService.makeFullImageURL(seed: 2)
        )
    }
}
