//
//  PostViewModel.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation
import Combine


class PostViewModel: ObservableObject {
    
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
            
            // Make sure new items display on top
            self.posts.sort { $0.id > $1.id }
            
            // Update state
            self.listState = self.posts.isEmpty ? .empty : .loaded
        }
        .store(in: &cancellables)
    }
    
    func addPost(title: String, content: String, creationCompletion: @escaping (Bool, String)->Void) {
        
        // Form Validation
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let trimmedContent = content.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedTitle.isEmpty && !trimmedContent.isEmpty
        else {
            creationCompletion(false, Constants.Texts.Errors.createPostInvalidForm)
            return
        }
        
        // Make sure we use a non existing ID
        let latestPostID = posts.first?.id ?? posts.count
        let newPostID = latestPostID + 1
        
        // Call the API to create a post
        service.createPost(
            postId: newPostID,
            title: trimmedTitle,
            body: trimmedContent
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            
            if case .failure(let error) = completion {
                // Handle error state
                creationCompletion(false, error.localizedDescription)
            }
        }
        receiveValue: { [weak self] newPost in
            
            guard let self else { return }
            
            // Append new item on top
            self.posts.insert(newPost, at: .zero)
            
            // Update state
            self.listState = self.posts.isEmpty ? .empty : .loaded
            
            creationCompletion(true, "")
        }
        .store(in: &cancellables)
    }
    
    func deletePost(at index: Int) {
        
        // Get the selected post
        let postToDelete = posts[index]
        
        // Call API
        service.deletePost(postId: postToDelete.id)
        
        // Remove from cache
        CacheService.shared.deleteObject(postToDelete)
        
        // Remove item from data
        posts.remove(at: index)
        
        // Update state
        self.listState = self.posts.isEmpty ? .empty : .loaded
    }
}
