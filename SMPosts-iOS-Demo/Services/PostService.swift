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
    
    func fetchDTOUsers() -> AnyPublisher<[UserDTO], Error> // Mainly for Unit Testing
    func fetchDTOComments() -> AnyPublisher<[CommentDTO], Error> // Mainly for Unit Testing
    func fetchDTOPosts() -> AnyPublisher<[PostDTO], Error>
    
    func fetchDTOUser(userId: Int) -> AnyPublisher<UserDTO?, Error>
    func fetchDTOComments(postId: Int) -> AnyPublisher<[CommentDTO], Error>
    
    func fetchPosts() -> AnyPublisher<[Post], Error>
    func createPost(postId: Int, title: String, body: String) -> AnyPublisher<Post, Error>
    func deletePost(postId: Int) // Fire and forget (good enough for this demo project)
}

// MARK: - Error types

enum PostServiceError: LocalizedError {
    
    case failedToLoadMockData
    case failedToCreatePost
    case noInternet
    
    var errorDescription: String? {
        switch self {
            case .failedToLoadMockData: return Constants.Texts.Errors.mockDataLoadingFailed
            case .failedToCreatePost: return Constants.Texts.Errors.createPostFailed
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
    
    private func fetch<T: Decodable>(from url: URL?) -> AnyPublisher<[T], Error> {
        
        guard let url,
              let data = try? Data(contentsOf: url)
        else {
            Logger.log("Cannot load mock file", level: .error)
            
            return Fail(error: PostServiceError.failedToLoadMockData)
                .eraseToAnyPublisher()
        }

        do {
            let response = try JSONDecoder().decode([T].self, from: data)
                        
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
    
    func createPost(postId: Int,
                    title: String,
                    body: String) -> AnyPublisher<Post, Error> {
                
        // Create a mock new Post (hence not having comments)
        let mockPost = Post(
            id: postId,
            title: title,
            content: body,
            authorEmail: "mockuser@smposts.com",
            comments: [],
            thumbnailURL: Self.makeThumbnailImageURL(seed: postId),
            detailImageURL: Self.makeFullImageURL(seed: postId)
        )
        
        return Just(mockPost)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func deletePost(postId: Int) {
        
        Logger.log(
            "Mock deletePost called for postId: \(postId)",
            level: .debug
        )
    }
}

// MARK: - Real Service

class PostService: PostServiceProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    private func fetch<T: Cachable>(from url: URL?) -> AnyPublisher<[T], Error> {
        
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
            .decode(type: [T].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[T], Error> in
                
                Logger.log("Failed to fetch or decode data: \(error)", level: .error)
                return Fail(error: error).eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { objects in
                CacheService.shared.saveArrayOfObjects(objects)
            })
            .eraseToAnyPublisher()
    }
    
    func fetchDTOPosts() -> AnyPublisher<[PostDTO], Error> {
        loadFromCache() ?? fetch(from: Constants.URLs.Posts.apiURL)
    }
    
    func fetchDTOComments() -> AnyPublisher<[CommentDTO], Error> {
        loadFromCache() ?? fetch(from: Constants.URLs.Comments.apiURL)
    }
    
    func fetchDTOUsers() -> AnyPublisher<[UserDTO], Error> {
        loadFromCache() ?? fetch(from: Constants.URLs.Users.apiURL)
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
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        
        loadFromCache()
        ??
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
        .handleEvents(receiveOutput: { objects in
            CacheService.shared.saveArrayOfObjects(objects)
        })
        .eraseToAnyPublisher()
    }
    
    private func loadFromCache<T: Cachable>() -> AnyPublisher<[T], Error>? {
        
        let cachedObjects: [T] = CacheService.shared.loadArrayOfObjects()
        
        if cachedObjects.isEmpty {
            return nil
        }
        
        return Just(cachedObjects)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func createPost(postId: Int,
                    title: String,
                    body: String) -> AnyPublisher<Post, Error> {
        
        guard let url = Constants.URLs.Posts.apiURL else {
            return Fail(error: URLError(.badURL))
            .eraseToAnyPublisher()
        }
        
        guard ReachabilityHelper.shared.hasInternetAccess else {
            return Fail(error: PostServiceError.noInternet)
            .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Compose the post body with a fake user id
        let bodyDict: [String: Any] = [
            "userId": 0,
            "title": title,
            "body": body
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
        }
        catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return data
        }
        .decode(type: PostDTO.self, decoder: JSONDecoder())
        .flatMap { receivedPostDTO -> AnyPublisher<Post?, Never> in
            
            let newPostDTO = PostDTO(
                id: postId, // Making sure we use our post ID
                userId: Int.random(in: 1...10), // Making sure we have a valid user ID
                title: receivedPostDTO.title,
                body: receivedPostDTO.body
            )
            
            return self.makePost(postDTO: newPostDTO)
        }
        .tryMap { post in
            
            guard let post else {
                throw PostServiceError.failedToCreatePost
            }
            
            let postWithoutComments = Post(
                id: post.id,
                title: title, // Making sure we use our title
                content: body, // Making sure we use our content
                authorEmail: post.authorEmail,
                comments: [], // A new post shouldn't have comments
                thumbnailURL: post.thumbnailURL,
                detailImageURL: post.detailImageURL
            )
            
            return postWithoutComments
        }
        .handleEvents(receiveOutput: { object in
            CacheService.shared.saveObject(object)
        })
        .eraseToAnyPublisher()
    }
    
    func deletePost(postId: Int) {
        
        guard let url = URL(string: "\(Constants.URLs.Posts.apiBase)/\(postId)") else {
            Logger.log("Failed to create post deletion URL", level: .warning)
            return
        }
        
        guard ReachabilityHelper.shared.hasInternetAccess else {
            Logger.log("No internet access to delete post", level: .warning)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }
        .sink(receiveCompletion: { completion in
            
            switch completion {
                    
                case .finished:
                    Logger.log("Successfully deleted post with ID \(postId)", level: .debug)
                    
                case .failure(let error):
                    Logger.log("Failed to delete post with ID \(postId): \(error)", level: .warning)
            }
        }, receiveValue: {})
        .store(in: &cancellables)
    }
}

// MARK: - Common implementation

extension PostServiceProtocol {

    fileprivate func makePost(postDTO: PostDTO) -> AnyPublisher<Post?, Never> {
        
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
                thumbnailURL: Self.makeThumbnailImageURL(seed: postDTO.id),
                detailImageURL: Self.makeFullImageURL(seed: postDTO.id)
            )
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
    
    static func makeThumbnailImageURL(seed: Int) -> URL? {
        
        let urlString = Constants.URLs.Images.apiBase
                      + String(seed)
                      + Constants.URLs.Images.thumbnailSuffix
        
        let url = URL(string: urlString)
        return url
    }
    
    static func makeFullImageURL(seed: Int) -> URL? {
        
        let urlString = Constants.URLs.Images.apiBase
                      + String(seed)
                      + Constants.URLs.Images.fullSuffix
        
        let url = URL(string: urlString)
        return url
    }
}
