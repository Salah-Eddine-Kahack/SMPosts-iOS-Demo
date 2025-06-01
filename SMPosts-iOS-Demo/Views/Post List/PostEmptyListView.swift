//
//  PostEmptyListView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 01/06/2025.
//

import SwiftUI


struct PostEmptyListView: View {
    
    // MARK: - Properties
    
    var message: String
    @ObservedObject var viewModel: PostViewModel
    
    // MARK: - UI
    
    var body: some View {
        
        VStack(spacing: Constants.Sizes.mediumSpacing) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button {
                viewModel.loadPosts()
            }
            label: {
                Text(Constants.Texts.PostList.loadPostsButtonTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Constants.Sizes.mediumSpacing)
                    .padding(.vertical, Constants.Sizes.regularSpacing)
                    .background(Constants.Colors.primary)
                    .cornerRadius(Constants.Sizes.regularSpacing)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PostEmptyListView(
        message: Constants.Texts.PostList.emptyMessage,
        viewModel: PostViewModel(
            appEnvironment: .mock
        )
    )
}
