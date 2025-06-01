//
//  PostViewModel.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation
import Combine


class PostListViewModel: ObservableObject {
    
    // MARK: - Enums
    
    enum ListState {
        case empty
        case loading
        case loaded
        case error(message: String)
    }
    
    // MARK: - Properties
    
    private let service: PostServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var posts: [Post] = []
    @Published var listState: ListState = .empty
    
    // MARK: - Life cycle
    
    init(appEnvironment: AppEnvironment) {
        service = PostServiceFactory.makeService(environment: appEnvironment)
    }
    
    // MARK: - Methods
    
    func loadPosts() {
        
        // Only load posts if empty
        if case .loaded = listState {
            Logger.log("Tried to load posts while already loaded.", level: .debug)
            return
        }
        
        // Avoid multiple fetches
        if case .loading = listState {
            Logger.log("Tried to load posts while already loading.", level: .debug)
            return
        }
        
        // Update state
        listState = .loading
        
        // Load posts
        service.fetchPosts()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            
            guard let self else { return }
            
            if case .failure(let error) = completion {
                // Handle error state
                self.listState = .error(message: error.localizedDescription)
            }
        }
        receiveValue: { [weak self] receivedPosts in
            
            guard let self else { return }
            
            // Append new items
            self.posts.append(contentsOf: receivedPosts)
            
            // Update state
            self.listState = self.posts.isEmpty ? .empty : .loaded
        }
        .store(in: &cancellables)
    }
}
