//
//  PostServiceTests.swift
//  SMPosts-iOS-DemoTests
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import XCTest
import Combine
@testable import SMPosts_iOS_Demo


final class PostServiceTests: XCTestCase {

    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Tests

    func test_PostService_fetchDTOPosts_from_mock_data() throws {
        
        // Setup test
        let expectation = self.expectation(description: "Fetch posts expectation")
        let service = PostServiceFactory.makeService(environment: .mock)
        
        try XCTContext.runActivity(
            named: "fetchDTOPosts should be able to decode and return a list of posts"
        ) { _ in
            
            var receivedPosts: [PostDTO] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOPosts()
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { posts in
                receivedPosts = posts
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0, handler: nil)
            
            // Check results
            XCTAssertNil(
                receivedError,
                "Expected no error, but received \(receivedError.debugDescription) instead"
            )
            
            XCTAssertEqual(
                receivedPosts.count, 100,
                "Expected 100 posts, but received \(receivedPosts.count) instead"
            )
            
            let firstPost = try XCTUnwrap(receivedPosts.first)
            let expectedFirstPostTitle = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
            
            XCTAssertEqual(
                firstPost.title,
                expectedFirstPostTitle,
                "Expected first post's title to be \"\(expectedFirstPostTitle)\", but got \(firstPost.title) instead"
            )
            
            let lastPost = try XCTUnwrap(receivedPosts.last)
            let expectedLastPostBody = "cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut"
            
            XCTAssertEqual(
                lastPost.body,
                expectedLastPostBody,
                "Expected last post's body to be \"\(expectedLastPostBody)\", but got \(lastPost.body) instead"
            )
        }
    }
    
    func test_PostService_fetchDTOComments_from_mock_data() throws {
        
        // Setup test
        let expectation = self.expectation(description: "Fetch comments expectation")
        let service = PostServiceFactory.makeService(environment: .mock)
        
        try XCTContext.runActivity(
            named: "fetchDTOComments should be able to decode and return a list of comments"
        ) { _ in
            
            var receivedComments: [CommentDTO] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOComments()
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { comments in
                receivedComments = comments
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0, handler: nil)
            
            // Check results
            XCTAssertNil(
                receivedError,
                "Expected no error, but received \(receivedError.debugDescription) instead"
            )
            
            XCTAssertEqual(
                receivedComments.count, 500,
                "Expected 500 comments, but received \(receivedComments.count) instead"
            )
            
            let firstComment = try XCTUnwrap(receivedComments.first)
            let expectedFirstCommentName = "id labore ex et quam laborum"
            
            XCTAssertEqual(
                firstComment.name,
                expectedFirstCommentName,
                "Expected first comment name to be \"\(expectedFirstCommentName)\", but got \(firstComment.name) instead"
            )
            
            let lastComment = try XCTUnwrap(receivedComments.last)
            let expectedLastCommentEmail = "Emma@joanny.ca"
            
            XCTAssertEqual(
                lastComment.email,
                expectedLastCommentEmail,
                "Expected last comment email to be \"\(expectedLastCommentEmail)\", but got \(lastComment.email) instead"
            )
        }
    }
    
    func test_PostService_fetchDTOUsers_from_mock_data() throws {
        
        // Setup test
        let expectation = self.expectation(description: "Fetch users expectation")
        let service = PostServiceFactory.makeService(environment: .mock)
        
        try XCTContext.runActivity(
            named: "fetchDTOUsers should be able to decode and return a list of users"
        ) { _ in
            
            var receivedUsers: [UserDTO] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOUsers()
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { users in
                receivedUsers = users
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0, handler: nil)
            
            // Check results
            XCTAssertNil(
                receivedError,
                "Expected no error, but received \(receivedError.debugDescription) instead"
            )
            
            XCTAssertEqual(
                receivedUsers.count, 10,
                "Expected 10 users, but received \(receivedUsers.count) instead"
            )
            
            let firstUser = try XCTUnwrap(receivedUsers.first)
            let expectedFirstUserCity = "Gwenborough"
            
            XCTAssertEqual(
                firstUser.address.city,
                expectedFirstUserCity,
                "Expected first user's city to be \"\(expectedFirstUserCity)\", but got \(firstUser.address.city) instead"
            )
            
            let lastUser = try XCTUnwrap(receivedUsers.last)
            let expectedLastUserCompanyName = "Hoeger LLC"
            
            XCTAssertEqual(
                lastUser.company.name,
                expectedLastUserCompanyName,
                "Expected last user's company name to be \"\(expectedLastUserCompanyName)\", but got \(lastUser.company.name) instead"
            )
        }
    }
    
    func test_PostService_fetchUser_from_mock_data() throws {
        
        let service = PostServiceFactory.makeService(environment: .mock)
        
        XCTContext.runActivity(
            named: "fetchDTOUser should return nil for an unknown user ID"
        ) { _ in
            
            // Setup test 1
            let expectation = self.expectation(description: "Fetch user with an unknown user ID")
            var receivedUser: UserDTO?
            var receivedError: Error?
            
            service.fetchDTOUser(userId: -1)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { user in
                receivedUser = user
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(receivedError, "Expected no error, but got \(String(describing: receivedError)) instead")
            XCTAssertNil(receivedUser, "Expected nil for an unknown user ID, but somehow got a user")
        }
        
        try XCTContext.runActivity(
            named: "fetchDTOUser should return a valid user for a known user ID"
        ) { _ in
            
            // Setup test 2
            let expectation = self.expectation(description: "Fetch user with a known user ID")
            var receivedUser: UserDTO?
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOUser(userId: 3)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { user in
                receivedUser = user
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(receivedError, "Expected no error, but got \(String(describing: receivedError)) instead")
            
            let user = try XCTUnwrap(receivedUser)
            let expectedUserEmail = "Nathan@yesenia.net"
            let expectedUserWebsite = "ramiro.info"
            
            XCTAssertEqual(
                user.email,
                expectedUserEmail,
                "Expected user's email to be \"\(expectedUserEmail)\", but got \(user.email) instead"
            )
            
            XCTAssertEqual(
                user.website,
                expectedUserWebsite,
                "Expected user's website to be \"\(expectedUserWebsite)\", but got \(user.website) instead"
            )
        }
    }

    func test_PostService_fetchComments_for_postId_from_mock_data() throws {
        
        let service = PostServiceFactory.makeService(environment: .mock)
        
        XCTContext.runActivity(
            named: "fetchDTOComments should return zero comments for an unknown post ID"
        ) { _ in
            
            // Setup test 1
            let expectation = self.expectation(description: "Fetch comments for an unknown post ID")
            var receivedComments: [CommentDTO] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOComments(postId: -1)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { comments in
                receivedComments = comments
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(receivedError, "Expected no error, but got \(String(describing: receivedError)) instead")
            XCTAssertTrue(receivedComments.isEmpty, "Expected zero comments, but somehow got \(receivedComments.count)")
        }
        
        try XCTContext.runActivity(
            named: "fetchDTOComments should return a list of valid comments for a known post ID"
        ) { _ in
            
            // Setup test 2
            let expectation = self.expectation(description: "Fetch comments for a known post ID")
            var receivedComments: [CommentDTO] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchDTOComments(postId: 2)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { comments in
                receivedComments = comments
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(receivedError, "Expected no error, but got \(String(describing: receivedError)) instead")
            XCTAssertGreaterThan(receivedComments.count, .zero, "Expected a non-empty list of comments")
            
            let firstComment = try XCTUnwrap(receivedComments.first)
            let expectedFirstCommentID = 6
            
            XCTAssertEqual(
                firstComment.id,
                expectedFirstCommentID,
                "Expected first comment's ID to be \"\(expectedFirstCommentID)\", but got \(firstComment.id) instead"
            )
            
            let lastComment = try XCTUnwrap(receivedComments.last)
            let expectedLastCommentName = "eaque et deleniti atque tenetur ut quo ut"
            
            XCTAssertEqual(
                lastComment.name,
                expectedLastCommentName,
                "Expected last comment's name to be \"\(expectedLastCommentName)\", but got \(lastComment.name) instead"
            )
        }
    }
    
    func test_PostService_fetchPosts_from_mock_data() throws {
        
        let service = PostServiceFactory.makeService(environment: .mock)
        let expectation = self.expectation(description: "Fetch displayable posts from mock")
        
        try XCTContext.runActivity(
            named: "fetchPosts should return a list of valid displayable posts from mock data"
        ) { _ in
            
            var receivedPosts: [Post] = []
            var receivedError: Error?
            
            // Fetch data
            service.fetchPosts()
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { posts in
                receivedPosts = posts
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(
                receivedError,
                "Expected no error, but received \(receivedError.debugDescription) instead"
            )
            
            XCTAssertEqual(
                receivedPosts.count, 100,
                "Expected 100 posts, but received \(receivedPosts.count) instead"
            )
            
            let firstPost = try XCTUnwrap(receivedPosts.first)
            let expectedFirstPostAuthorEmail = "sincere@april.biz"
            
            XCTAssertEqual(
                firstPost.authorEmail,
                expectedFirstPostAuthorEmail,
                "Expected first post's author email to be \(expectedFirstPostAuthorEmail), but got \(firstPost.authorEmail) instead"
            )
            
            let firstPostFirstComment = try XCTUnwrap(firstPost.comments.first)
            let expectedFirstPostFistCommentContent = "Laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
            
            XCTAssertEqual(
                firstPostFirstComment.content,
                expectedFirstPostFistCommentContent,
                "Expected first post's first comment's content to be \(expectedFirstPostFistCommentContent), but got \(firstPostFirstComment.content) instead"
            )
            
            let lastPost = try XCTUnwrap(receivedPosts.last)
            let expectedLastPostCommentsCount = 5
            
            XCTAssertEqual(
                lastPost.comments.count,
                expectedLastPostCommentsCount,
                "Expected last post's comments to be \(expectedLastPostCommentsCount), but got \(lastPost.comments.count) instead"
            )
            
            let lastPostLastComment = try XCTUnwrap(lastPost.comments.last)
            let expectedLastPostLastCommentAuthorEmail = "emma@joanny.ca"
            
            XCTAssertEqual(
                lastPostLastComment.authorEmail,
                expectedLastPostLastCommentAuthorEmail,
                "Expected last post's last comment's author's email to be \(expectedLastPostLastCommentAuthorEmail), but got \(lastPostLastComment.authorEmail) instead"
            )
        }
    }
    
    func test_PostService_createPost() throws {
        
        let service = PostServiceFactory.makeService(environment: .mock)
        let expectation = self.expectation(description: "createPost should return a mock Post object")
        
        try XCTContext.runActivity(
            named: "createPost should return a mock Post object"
        ) { _ in
            
            var receivedPost: Post?
            var receivedError: Error?
            
            let inputedPostID: Int = 1
            let inputedTitle: String = "Test Title"
            let inputedBody: String = "Test Body"
            
            // Create Post
            service.createPost(
                postId: inputedPostID,
                title: inputedTitle,
                body: inputedBody
            )
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    case .failure(let error): receivedError = error
                    case .finished: break
                }
                
                expectation.fulfill()
            },
            receiveValue: { post in
                receivedPost = post
            })
            .store(in: &cancellables)
            
            // Give it time to load
            waitForExpectations(timeout: 5.0)
            
            // Check results
            XCTAssertNil(receivedError, "Expected no error, but got \(String(describing: receivedError)) instead")
            
            let post = try XCTUnwrap(receivedPost)
            
            XCTAssertEqual(
                post.id,
                inputedPostID,
                "Expected new post ID to be equivalent to the inputed ID \"\(inputedPostID)\", but got \(post.id) instead"
            )
            
            XCTAssertEqual(
                post.title,
                inputedTitle,
                "Expected new post title to be equivalent to the inputed title \"\(inputedTitle)\", but got \(post.title) instead"
            )
            
            XCTAssertEqual(
                post.content,
                inputedBody,
                "Expected new post body to be equivalent to the inputed body \"\(inputedBody)\", but got \(post.content) instead"
            )
            
            XCTAssertEqual(
                post.comments.count,
                .zero,
                "Expected new post to have no comments, but got \(post.comments.count) instead"
            )
        }
    }
}
