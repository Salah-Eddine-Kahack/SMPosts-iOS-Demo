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
        
        Text("PostListView")
    }
    
    // MARK: - Methods
}


// MARK: - Preview

#Preview {
    PostListView(appEnvironment: .mock)
}
