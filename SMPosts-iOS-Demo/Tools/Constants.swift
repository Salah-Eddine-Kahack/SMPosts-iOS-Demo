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
        
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    }

    // MARK: - Sizes
    
    struct Sizes {
        
        static let tinySpacing: CGFloat = 4.0
        static let smallSpacing: CGFloat = 8.0
        static let regularSpacing: CGFloat = 16.0
        static let mediumSpacing: CGFloat = 20.0
        static let largeSpacing: CGFloat = 32.0
        static let cornerRadius: CGFloat = 10.0
        static let shadowRadius: CGFloat = 12.0
        static let largeCornerRadius: CGFloat = cornerRadius + regularSpacing
        
        struct PostList {
            static let thumbnailImageWidth: CGFloat = 280.0
            static let thumbnailImageHeight: CGFloat = 140.0
        }
        
        struct PostDetail {
            static let fullImageWidth: CGFloat = 1024.0
            static let fullImageHeight: CGFloat = 512.0
            static let headerImageHeight: CGFloat = 200.0
        }
        
        struct PostForm {
            static let contentTextViewHeight: CGFloat = 200.0
        }
    }
    
    // MARK: - Icons
    
    struct Icons {
        static let add = Image(systemName: "plus")
        static let comment = Image(systemName: "bubble.left.and.bubble.right")
    }
    
    // MARK: - Texts
    
    struct Texts {
        
        private static let context: String = "general"
        static let okButtonTitle: String = NSLocalizedString("OK", comment: context)
        
        struct PostList {
            private static let context: String = "post-list"
            static let title: String = NSLocalizedString("Posts", comment: context)
            static let emptyMessage: String = NSLocalizedString("No posts found.\nLoad or create a new post.", comment: context)
            static let loadingMessageText: String = NSLocalizedString("Loading...", comment: context)
            static let loadPostsButtonTitle: String = NSLocalizedString("Load Posts", comment: context)
        }
        
        struct PostDetail {
            private static let context: String = "post-detail"
            static let commentsLabelText: String = NSLocalizedString("Comments:", comment: context)
            static let emptyCommentsText: String = NSLocalizedString("No comments", comment: context)
        }
        
        struct PostForm {
            private static let context: String = "post-form"
            static let title: String = NSLocalizedString("New Post", comment: context)
            static let titleLabelText: String = NSLocalizedString("Title:", comment: context)
            static let contentLabelText: String = NSLocalizedString("Content:", comment: context)
            static let submitButtonTitle: String = NSLocalizedString("Create Post", comment: context)
            static let cancelButtonTitle: String = NSLocalizedString("Cancel", comment: context)
            static let titlePlaceholderText: String = NSLocalizedString("What's on your mind ?", comment: context)
            static let contentPlaceholderText: String = NSLocalizedString("Describe your thoughts...", comment: context)
            static let createPostErrorAlertTitle: String = NSLocalizedString("Error", comment: context)
        }
        
        struct Errors {
            private static let context: String = "error-messages"
            static let mockDataLoadingFailed: String = NSLocalizedString("Failed to load mock data.", comment: context)
            static let noInternetConnection: String = NSLocalizedString("No internet connection, please try again later", comment: context)
            static let createPostFailed: String = NSLocalizedString("Failed to create a new post. Please try again later.", comment: context)
            static let createPostInvalidForm: String = NSLocalizedString("Please fill all fields.", comment: context)
        }
    }
    
    // MARK: - URLs
    
    struct URLs {
        
        struct Posts {
            static let mockFileURL = Bundle.main.url(forResource: "posts", withExtension: "json")
            static let apiBase = "https://jsonplaceholder.typicode.com/posts"
            static let apiURL = URL(string: apiBase)
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
            static let thumbnailSuffix = "/\(Int(Sizes.PostList.thumbnailImageWidth))" + "/\(Int(Sizes.PostList.thumbnailImageHeight))"
            static let fullSuffix = "/\(Int(Sizes.PostDetail.fullImageWidth))" + "/\(Int(Sizes.PostDetail.fullImageHeight))"
        }
    }
}
