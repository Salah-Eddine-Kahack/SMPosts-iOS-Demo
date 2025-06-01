//
//  PostImageView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 31/05/2025.
//

import SwiftUI


struct PostImageView: View {
    
    // MARK: - Properties
    
    var url: URL?
    
    // MARK: - UI
    
    var body: some View {
        
        ZStack {
            
            Constants.Colors.primary.opacity(0.2)
            
            CachedAsyncImage(url: url) { phase in
                
                switch phase {
                        
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        
                    default:
                        Text("Failed to load image")
                        .foregroundColor(Constants.Colors.secondary.opacity(0.5))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Constants.Colors.secondaryBackground
        .edgesIgnoringSafeArea(.all)
        
        PostImageView(
            url: Post.mock.thumbnailURL
        )
        .padding()
        .background(Constants.Colors.background)
        .cornerRadius(Constants.Sizes.cornerRadius)
        .padding()
    }
}
