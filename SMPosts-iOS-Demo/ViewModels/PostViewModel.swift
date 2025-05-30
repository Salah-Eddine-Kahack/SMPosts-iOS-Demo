//
//  PostViewModel.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


class PostListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let service: PostServiceProtocol
    
    // MARK: - Life cycle
    
    init(appEnvironment: AppEnvironment) {
        service = PostServiceFactory.makeService(environment: appEnvironment)
    }
    
    // MARK: - Methods
}
