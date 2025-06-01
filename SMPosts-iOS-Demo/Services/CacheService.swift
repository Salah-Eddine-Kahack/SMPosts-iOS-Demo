//
//  CacheService.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 01/06/2025.
//

import Foundation


protocol Cachable: Codable {
    
    static var cacheKey: String { get }
}


final class CacheService {

    // MARK: - Constants
    
    struct Keys {
        
        fileprivate static let clearOnLaunch = "clear_cache_on_launch_key"

        static let postsDTO = "posts_dto_cache_key"
        static let commentsDTO = "comments_dto_cache_key"
        static let usersDTO = "users_dto_cache_key"
        
        static let posts = "posts_cache_key"
        static let comments = "comments_cache_key"
        
        static var allData: [String] {
            [postsDTO, commentsDTO, usersDTO, posts, comments]
        }
    }
    
    // MARK: - Properties
    
    private let defaults = UserDefaults.standard

    // MARK: - Singleton
    
    static let shared = CacheService()
    
    // MARK: - Methods

    func save<T: Cachable>(_ objects: [T]) {
        
        do {
            let data = try JSONEncoder().encode(objects)
            defaults.set(data, forKey: T.cacheKey)
            Logger.log("Saved \(T.cacheKey) to cache", level: .debug)
        }
        catch {
            Logger.log("Failed to encode \(T.cacheKey): \(error)", level: .error)
        }
    }

    func load<T: Cachable>() -> [T] {
        
        guard let data = defaults.data(forKey: T.cacheKey) else {
            Logger.log("No cached \(T.cacheKey) found", level: .debug)
            return []
        }

        do {
            return try JSONDecoder().decode([T].self, from: data)
        }
        catch {
            Logger.log("Failed to decode \(T.cacheKey): \(error)", level: .error)
            return []
        }
    }

    func clear(cacheKey: String) {
        
        if defaults.object(forKey: cacheKey) != nil {
            defaults.removeObject(forKey: cacheKey)
            Logger.log("Cleared \(cacheKey) cache", level: .debug)
        }
        else {
            Logger.log("No cache found for: \(cacheKey)", level: .debug)
        }
    }
}

// MARK: - App Settings

extension CacheService {
    
    func clearCacheAtLaunchIfNeeded() {
        
        let shouldClear = defaults.bool(forKey: Keys.clearOnLaunch)

        if shouldClear {
            
            clearAllData()
            
            Logger.log("Cache cleared via iOS Settings toggle", level: .debug)
            
            defaults.set(false, forKey: Keys.clearOnLaunch)
        }
    }
    
    func clearAllData() {
        
        Keys.allData.forEach {
            clear(cacheKey: $0)
        }
        
        Logger.log("All caches cleared", level: .debug)
    }
}
