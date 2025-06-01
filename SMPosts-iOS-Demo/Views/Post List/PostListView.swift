//
//  PostListView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


struct PostListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: PostListViewModel
    
    // MARK: - Life cycle

    init(appEnvironment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: PostListViewModel(appEnvironment: appEnvironment))
    }
    
    // MARK: - UI

    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                switch viewModel.listState {
                        
                    case .empty:
                        Text(Constants.Texts.PostList.emptyMessage)
                            .font(.headline)
                        
                    case .loading:
                        ProgressView {
                            Text(Constants.Texts.PostList.loadingMessageText)
                                .font(.headline)
                        }
                        
                    case .loaded:
                        
                        List {
                            ForEach(viewModel.posts) { post in
                                NavigationLink(destination: PostDetailView(post: post)) {
                                    
                                    PostRowView(post: post)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listRowSpacing(Constants.Sizes.regularSpacing)
                        
                    case .error(let message):
                        
                        VStack(spacing: Constants.Sizes.mediumSpacing) {
                            Text(message)
                            .font(.headline)
                            
                            Button {
                                viewModel.loadPosts()
                            }
                            label: {
                                Text(Constants.Texts.PostList.loadPostsButtonTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Constants.Colors.primary)
                                .cornerRadius(Constants.Sizes.regularSpacing)
                            }
                        }
                }
            }
            .navigationBarTitle(Text(Constants.Texts.PostList.title))
            .onAppear {
                viewModel.loadPosts()
            }
        }
    }
}


// MARK: - Preview

#Preview {
    PostListView(
        appEnvironment: .mock
    )
}
