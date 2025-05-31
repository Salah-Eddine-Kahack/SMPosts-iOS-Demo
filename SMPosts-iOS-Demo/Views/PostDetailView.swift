//
//  PostDetailView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


struct PostDetailView: View {
    
    // MARK: - Properties
    
    var post: Post
    
    // MARK: - Getters
    
    private var commentsSectionTitle: String {
        
        var commentsSectionTitle = Constants.Texts.PostDetail.commentsLabelText
        
        if post.comments.isEmpty {
            commentsSectionTitle = Constants.Texts.PostDetail.emptyCommentsText
        }
        
        return commentsSectionTitle
    }
    
    // MARK: - UI
    
    var body: some View {
        
        ZStack {
            
            Constants.Colors.secondaryBackground
            .ignoresSafeArea(edges: .all)
            
            VStack(spacing: .zero) {
                
                VStack(alignment: .leading, spacing: Constants.Sizes.regularSpacing) {
                    
                    PostImageView(url: post.detailImageURL)
                    .cornerRadius(Constants.Sizes.cornerRadius)
                    
                    VStack(alignment: .leading, spacing: Constants.Sizes.smallSpacing) {
                        
                        Text(post.title)
                            .font(.headline)
                            .foregroundStyle(Constants.Colors.primary)
                        
                        Text(post.content)
                            .font(.body)
                    }
                }
                .padding(.vertical, Constants.Sizes.regularSpacing)
                .padding(.horizontal, Constants.Sizes.mediumSpacing)
                .background(Constants.Colors.background)
                
                Text(commentsSectionTitle)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.top, Constants.Sizes.regularSpacing)

                ScrollView {
                    
                    VStack(spacing: .zero) {
                        
                        ForEach(post.comments.prefix(3)) { comment in
                            
                            VStack(alignment: .leading, spacing: Constants.Sizes.smallSpacing) {
                                
                                HStack(spacing: .zero) {
                                    
                                    Text(comment.authorEmail)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Constants.Colors.primary)
                                    
                                    Spacer()
                                }
                                
                                Text(comment.content)
                                    .font(.body)
                            }
                            .padding(Constants.Sizes.regularSpacing)
                            .background(Constants.Colors.background)
                            .cornerRadius(Constants.Sizes.cornerRadius)
                        }
                        .padding(.vertical, Constants.Sizes.tinySpacing)
                        .padding(.horizontal, Constants.Sizes.mediumSpacing)
                    }
                }
                .padding(.top, Constants.Sizes.smallSpacing)
                .padding(.bottom, Constants.Sizes.mediumSpacing)
                
                Spacer()
            }
            .background(Constants.Colors.secondaryBackground)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    PostDetailView(
        post: Post.mock
    )
}
