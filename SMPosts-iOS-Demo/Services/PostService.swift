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
    
    func fetchDTOUsers() -> AnyPublisher<[UserDTO], Error>
    func fetchDTOComments() -> AnyPublisher<[CommentDTO], Error>
    func fetchDTOPosts() -> AnyPublisher<[PostDTO], Error>
    
    func fetchDTOUser(userId: Int) -> AnyPublisher<UserDTO?, Error>
    func fetchDTOComments(postId: Int) -> AnyPublisher<[CommentDTO], Error>
    
    func fetchPosts() -> AnyPublisher<[Post], Error>
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
    
    func fetchDTOPosts() -> AnyPublisher<[PostDTO], Error> {
        fetch(from: Constants.URLs.Posts.mockFileURL)
    }
    
    func fetchDTOComments() -> AnyPublisher<[CommentDTO], Error> {
        fetch(from: Constants.URLs.Comments.mockFileURL)
    }
    
    func fetchDTOUsers() -> AnyPublisher<[UserDTO], Error> {
        fetch(from: Constants.URLs.Users.mockFileURL)
    }
    
    func fetchDTOUser(userId: Int) -> AnyPublisher<UserDTO?, Error> {
        
        fetchDTOUsers()
        .map { users in
            users.first { $0.id == userId }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchDTOComments(postId: Int) -> AnyPublisher<[CommentDTO], Error> {
        
        fetchDTOComments()
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
    
    func fetchDTOPosts() -> AnyPublisher<[PostDTO], Error> {
        fetch(from: Constants.URLs.Posts.apiURL)
    }
    
    func fetchDTOComments() -> AnyPublisher<[CommentDTO], Error> {
        fetch(from: Constants.URLs.Comments.apiURL)
    }
    
    func fetchDTOUsers() -> AnyPublisher<[UserDTO], Error> {
        fetch(from: Constants.URLs.Users.apiURL)
    }
    
    func fetchDTOUser(userId: Int) -> AnyPublisher<UserDTO?, Error> {
        
        let url = URL(string: "\(Constants.URLs.Users.apiBase)?id=\(userId)")
        
        return fetch(from: url)
            .map { (users: [UserDTO]) in
                users.first { $0.id == userId }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDTOComments(postId: Int) -> AnyPublisher<[CommentDTO], Error> {
        
        let url = URL(string: "\(Constants.URLs.Comments.apiBase)?postId=\(postId)")
        
        return fetch(from: url)
    }
}

// MARK: - Common implementation

extension PostServiceProtocol {

    func fetchPosts() -> AnyPublisher<[Post], Error> {
        
        fetchDTOPosts()
        .flatMap { postDTOs in
            Publishers.MergeMany(
                postDTOs.map {
                    self.makePost(postDTO: $0)
                }
            )
            .compactMap { $0 }
            .collect()
        }
        .eraseToAnyPublisher()
    }

    private func makePost(postDTO: PostDTO) -> AnyPublisher<Post?, Never> {
        
        // Loads user and comments data for the post
        let userPublisher = fetchDTOUser(userId: postDTO.userId)
        let commentsPublisher = fetchDTOComments(postId: postDTO.id)

        // Make a displayable `Post` object with all the data
        return Publishers.Zip(userPublisher, commentsPublisher)
        .map { user, commentDTOs -> Post? in
            
            guard let user = user else {
                Logger.log("User with ID \(postDTO.userId) not found.", level: .warning)
                return nil
            }

            let comments = commentDTOs.map {
                Comment(commentDTO: $0)
            }

            return Post(
                id: postDTO.id,
                title: postDTO.title,
                content: postDTO.body,
                authorEmail: user.email,
                comments: comments,
                thumbnailImageURL: makeThumbnailImageURL(seed: postDTO.id),
                detailImageURL: makeFullImageURL(seed: postDTO.id),
                thumbnailImage: nil,
                detailImage: nil
            )
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
    
    private func makeThumbnailImageURL(seed: Int) -> URL? {
        
        let urlString = Constants.URLs.Images.apiBase
                      + String(seed)
                      + Constants.URLs.Images.thumbnailSuffix
        
        let url = URL(string: urlString)
        return url
    }
    
    private func makeFullImageURL(seed: Int) -> URL? {
        
        let urlString = Constants.URLs.Images.apiBase
                      + String(seed)
                      + Constants.URLs.Images.fullSuffix
        
        let url = URL(string: urlString)
        return url
    }
}
