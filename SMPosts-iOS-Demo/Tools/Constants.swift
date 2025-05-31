//
//  Constants.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation
import SwiftUI


struct Constants {
    
    // MARK: - Colors
    
    struct Colors {
        static let primary = Color("AccentColor")
        static let secondary = Color("SecondaryAccentColor")
    }

    // MARK: - Sizes
    
    struct Sizes {
        
        static let tinySpacing: CGFloat = 4.0
        static let smallSpacing: CGFloat = 8.0
        static let regularSpacing: CGFloat = 16.0
        static let mediumSpacing: CGFloat = 20.0
        static let largeSpacing: CGFloat = 32.0
        static let cornerRadius: CGFloat = 10.0
        static let largeCornerRadius: CGFloat = cornerRadius + regularSpacing
        
        struct PostList {
            static let thumbnailImageSize: CGFloat = 64.0
        }
    }
    
    // MARK: - Icons
    
    struct Icons {
        static let add = Image(systemName: "plus")
    }
    
    // MARK: - Texts
    
    struct Texts {
        
        private static let context: String = "general"
        
        struct PostList {
            private static let context: String = "post-list"
            static let title: String = NSLocalizedString("Posts", comment: context)
            static let emptyMessage: String = NSLocalizedString("No posts found. Load or create a new post.", comment: context)
            static let loadPostsButtonTitle: String = NSLocalizedString("Load Posts", comment: context)
        }
        
        struct PostDetail {
            private static let context: String = "post-detail"
            static let commentsLabelText: String = NSLocalizedString("Comments:", comment: context)
        }
        
        struct PostForm {
            private static let context: String = "post-form"
            static let titleLabelText: String = NSLocalizedString("Title:", comment: context)
            static let contentLabelText: String = NSLocalizedString("Content:", comment: context)
        }
        
        struct Errors {
            private static let context: String = "error-messages"
            static let mockDataLoadingFailed: String = NSLocalizedString("Failed to load mock data.", comment: context)
            static let noInternetConnection: String = NSLocalizedString("No internet connection, please try again later", comment: context)
        }
    }
    
    // MARK: - URLs
    
    struct URLs {
        
        struct Posts {
            static let mockFileURL = Bundle.main.url(forResource: "posts", withExtension: "json")
            static let apiURL = URL(string: "https://jsonplaceholder.typicode.com/posts")
        }

        struct Comments {
            static let mockFileURL = Bundle.main.url(forResource: "comments", withExtension: "json")
            static let apiBase = "https://jsonplaceholder.typicode.com/comments"
            static let apiURL = URL(string: apiBase)
        }
        
        struct Users {
            static let mockFileURL = Bundle.main.url(forResource: "users", withExtension: "json")
            static let apiBase = "https://jsonplaceholder.typicode.com/users"
            static let apiURL = URL(string: apiBase)
        }
        
        struct Images {
            static let apiBase = "https://picsum.photos/seed/"
            static let thumbnailSuffix = "/320/320"
            static let fullSuffix = "/1024/1024"
        }
    }
}
