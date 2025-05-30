//
//  PostService.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation
import Combine


// MARK: - Protocol

protocol PostServiceProtocol {
    
    func fetchUsers() -> AnyPublisher<[UserDTO], Error>
    func fetchComments() -> AnyPublisher<[CommentDTO], Error>
    func fetchPosts() -> AnyPublisher<[PostDTO], Error>
    
    func fetchUser(userId: Int) -> AnyPublisher<UserDTO?, Error>
    func fetchComments(postId: Int) -> AnyPublisher<[CommentDTO], Error>
}

// MARK: - Error types

enum PostServiceError: LocalizedError {
    
    case failedToLoadMockData
    case noInternet
    
    var errorDescription: String? {
        switch self {
            case .failedToLoadMockData: return Constants.Texts.Errors.mockDataLoadingFailed
            case .noInternet: return Constants.Texts.Errors.noInternetConnection
        }
    }
}

// MARK: - Factory

struct PostServiceFactory {
    
    static func makeService(environment: AppEnvironment) -> PostServiceProtocol {
        
        switch environment {
            case .mock: MockPostService()
            case .real: PostService()
        }
    }
}

// MARK: - Mock Service

class MockPostService: PostServiceProtocol {
    
    private func fetch<T: Decodable>(from url: URL?) -> AnyPublisher<T, Error> {
        
        guard let url,
              let data = try? Data(contentsOf: url)
        else {
            Logger.log("Cannot load mock file", level: .error)
            
            return Fail(error: PostServiceError.failedToLoadMockData)
                .eraseToAnyPublisher()
        }

        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        catch {
            Logger.log("Error decoding mock file: \(error)", level: .error)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPosts() -> AnyPublisher<[PostDTO], Error> {
        fetch(from: Constants.URLs.Posts.mockFileURL)
    }
    
    func fetchComments() -> AnyPublisher<[CommentDTO], Error> {
        fetch(from: Constants.URLs.Comments.mockFileURL)
    }
    
    func fetchUsers() -> AnyPublisher<[UserDTO], Error> {
        fetch(from: Constants.URLs.Users.mockFileURL)
    }
    
    func fetchUser(userId: Int) -> AnyPublisher<UserDTO?, Error> {
        
        fetchUsers()
        .map { users in
            users.first { $0.id == userId }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentDTO], Error> {
        
        fetchComments()
        .map { comments in
            comments.filter { $0.postId == postId }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Real Service

class PostService: PostServiceProtocol {
    
    private func fetch<T: Decodable>(from url: URL?) -> AnyPublisher<T, Error> {
        
        guard let url = url else {
            Logger.log("Invalid API URL", level: .error)
            return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
        }
        
        guard ReachabilityHelper.shared.hasInternetAccess else {
            return Fail(error: PostServiceError.noInternet)
                   .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    
                    Logger.log("Bad server response", level: .error)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<T, Error> in
                
                Logger.log("Failed to fetch or decode data: \(error)", level: .error)
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchPosts() -> AnyPublisher<[PostDTO], Error> {
        fetch(from: Constants.URLs.Posts.apiURL)
    }

    func fetchComments() -> AnyPublisher<[CommentDTO], Error> {
        fetch(from: Constants.URLs.Comments.apiURL)
    }

    func fetchUsers() -> AnyPublisher<[UserDTO], Error> {
        fetch(from: Constants.URLs.Users.apiURL)
    }
    
    func fetchUser(userId: Int) -> AnyPublisher<UserDTO?, Error> {
        
        let url = URL(string: "\(Constants.URLs.Users.apiBase)?id=\(userId)")
        
        return fetch(from: url)
            .map { (users: [UserDTO]) in
                users.first { $0.id == userId }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[CommentDTO], Error> {
        
        let url = URL(string: "\(Constants.URLs.Comments.apiBase)?postId=\(postId)")
        
        return fetch(from: url)
    }
}
