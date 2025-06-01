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
            
            Rectangle()
            .fill(
                Gradient(
                    colors: [Constants.Colors.background, Constants.Colors.secondaryBackground]
                )
            )
            .ignoresSafeArea(edges: .all)
            
            ScrollView {
                
                VStack(spacing: .zero) {
                    
                    VStack(alignment: .leading, spacing: Constants.Sizes.regularSpacing) {
                        
                        PostImageView(url: post.detailImageURL)
                            .frame(height: Constants.Sizes.PostDetail.headerImageHeight)
                            .aspectRatio(
                                Constants.Sizes.PostDetail.fullImageWidth / Constants.Sizes.PostDetail.fullImageHeight,
                                contentMode: .fit
                            )
                            .cornerRadius(Constants.Sizes.cornerRadius)
                        
                        VStack(alignment: .leading, spacing: Constants.Sizes.smallSpacing) {
                            
                            HStack {
                                
                                Text(post.title)
                                    .font(.headline)
                                    .foregroundStyle(Constants.Colors.primary)
                                
                                Spacer()
                            }
                            
                            HStack {
                                
                                Text(post.content)
                                    .font(.body)
                                    .lineLimit(nil)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, Constants.Sizes.regularSpacing)
                    .padding(.horizontal, Constants.Sizes.mediumSpacing)
                    .background(Constants.Colors.background)
                    
                    Text(commentsSectionTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.top, Constants.Sizes.regularSpacing)
                    
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
                    .padding(.top, Constants.Sizes.smallSpacing)
                    .padding(.bottom, Constants.Sizes.mediumSpacing)
                    
                    Spacer()
                }
                .background(Constants.Colors.secondaryBackground)
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview

#Preview {
    PostDetailView(
        post: Post.mock
    )
}
