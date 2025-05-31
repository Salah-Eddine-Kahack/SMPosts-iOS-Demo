//
//  PostRowView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 31/05/2025.
//

import SwiftUI


struct PostRowView: View {
    
    // MARK: - Properties
    
    var post: Post
    
    // MARK: - UI
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Sizes.smallSpacing) {
            
            HStack(alignment: .top) {
                
                Text(post.authorEmail)
                    .font(.headline)
                    .foregroundStyle(Constants.Colors.primary)
                    .fontWeight(.medium)
                
                Spacer()
                
                HStack(spacing: Constants.Sizes.tinySpacing) {
                    
                    Constants.Icons.comment
                        .font(.subheadline)
                    
                    Text("\(post.comments.count)")
                        .font(.title3)
                        .fontWeight(.light)
                }
                .foregroundColor(.secondary)
            }
            
            Text(post.title)
                .font(.subheadline)
            
            PostImageView(url: post.thumbnailURL)
            .aspectRatio(
                Constants.Sizes.PostList.thumbnailImageWidth / Constants.Sizes.PostList.thumbnailImageHeight,
                contentMode: .fit
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(Constants.Sizes.cornerRadius)
        }
        .padding(.vertical, Constants.Sizes.smallSpacing)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Constants.Colors.secondaryBackground
        .edgesIgnoringSafeArea(.all)
        
        PostRowView(
            post: Post.mock
        )
        .padding()
        .background(Constants.Colors.background)
        .cornerRadius(Constants.Sizes.cornerRadius)
        .padding()
    }
}
