//
//  PostListView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


struct PostListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: PostViewModel
    @State private var isPresentingForm = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Getters
    
    private var showEditButton: Bool {
        
        if case .loaded = viewModel.listState {
            return true
        }
        
        return false
    }
    
    // MARK: - Life cycle

    init(appEnvironment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: PostViewModel(appEnvironment: appEnvironment))
    }
    
    // MARK: - UI

    var body: some View {
        
        NavigationView {
            
            Group {
                
                ZStack() {
                    
                    VStack(alignment: .center) {
                        
                        switch viewModel.listState {
                                
                            case .empty:
                                PostEmptyListView(
                                    message: Constants.Texts.PostList.emptyMessage,
                                    viewModel: viewModel
                                )
                                
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
                                    .onDelete(perform: deletePosts)
                                }
                                .listRowSpacing(Constants.Sizes.regularSpacing)
                                
                            case .error(let errorMessage):
                                
                                PostEmptyListView(
                                    message: errorMessage,
                                    viewModel: viewModel
                                )
                        }
                    }
                    
                    VStack(spacing: .zero) {
                        
                        Spacer()
                        
                        HStack(spacing: .zero) {
                            
                            Spacer()
                            
                            Button(action: {
                                isPresentingForm = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .padding(Constants.Sizes.mediumSpacing)
                                    .background(Constants.Colors.primary)
                                    .clipShape(Circle())
                                    .padding(.trailing, Constants.Sizes.largeSpacing)
                                    .padding(.bottom, Constants.Sizes.smallSpacing)
                                    .shadow(
                                        color: Constants.Colors.primary.opacity(0.3),
                                        radius: Constants.Sizes.shadowRadius
                                    )
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(
                Text(Constants.Texts.PostList.title)
            )
            .toolbar {
                if showEditButton {
                    EditButton()
                }
            }
            .onAppear {
                viewModel.loadPosts()
            }
            .sheet(isPresented: $isPresentingForm) {
                
                PostFormView { title, content in
                    
                    viewModel.addPost(title: title, content: content) { didSucceed, errorMessage in
                        
                        if !didSucceed {
                            showAlert = true
                            alertMessage = errorMessage
                        }
                        else {
                            isPresentingForm = false
                        }
                    }
                }
                .alert(
                    Constants.Texts.PostForm.createPostErrorAlertTitle,
                    isPresented: $showAlert
                ) {
                    Button(Constants.Texts.okButtonTitle, role: .cancel) {}
                }
                message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func deletePosts(at offsets: IndexSet) {
        
        offsets.forEach { index in
            viewModel.deletePost(at: index)
        }
    }
}

// MARK: - Preview

#Preview {
    PostListView(
        appEnvironment: .mock
    )
}
