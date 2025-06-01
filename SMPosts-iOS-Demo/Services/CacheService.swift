//
//  CacheService.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 01/06/2025.
//

import Foundation


protocol Cachable: Codable, Identifiable {
    
    static var cacheKey: String { get }
}


final class CacheService {

    // MARK: - Constants
    
    struct Keys {
        
        fileprivate static let clearOnLaunch = "clear_cache_on_launch_key"
        fileprivate static let currentAppEnvironmentKey = "app_environment_key"
        fileprivate static let previousAppEnvironmentKey = "previous_app_environment_key"

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

    func saveArrayOfObjects<T: Cachable>(_ objects: [T]) {
        do {
            let data = try JSONEncoder().encode(objects)
            defaults.set(data, forKey: T.cacheKey)
            Logger.log("Saved \(T.cacheKey) to cache", level: .debug)
        }
        catch {
            Logger.log("Failed to encode \(T.cacheKey): \(error)", level: .error)
        }
    }

    func saveObject<T: Cachable>(_ object: T) {
        
        var cachedObjects: [T] = loadArrayOfObjects()
        cachedObjects.append(object)
        
        saveArrayOfObjects(cachedObjects)
    }
    
    func deleteObject<T: Cachable>(_ object: T) {
        
        var cachedObjects: [T] = loadArrayOfObjects()
        
        cachedObjects.removeAll {
            $0.id == object.id
        }
        
        saveArrayOfObjects(cachedObjects)
    }
    
    func loadArrayOfObjects<T: Cachable>() -> [T] {
        
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

    func clearAllObjects(cacheKey: String) {
        
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
            
            Keys.allData.forEach {
                clearAllObjects(cacheKey: $0)
            }
            
            Logger.log("Cache cleared via iOS Settings toggle", level: .debug)
            
            defaults.set(false, forKey: Keys.clearOnLaunch)
        }
    }
    
    var appEnvironment: AppEnvironment {
        
        let rawValue = defaults.string(forKey: Keys.currentAppEnvironmentKey)
                    ?? AppEnvironment.real.rawValue
        
        let appEnvironment = AppEnvironment(rawValue: rawValue) ?? .real
        return appEnvironment
    }
    
    func refreshAppEnvironmentIfNeeded() {
        
        let previousAppEnvironment = defaults.string(forKey: Keys.previousAppEnvironmentKey)
        let currentAppEnvironment = defaults.string(forKey: Keys.currentAppEnvironmentKey)
        
        // Clear cache if app environment changed
        if previousAppEnvironment != currentAppEnvironment {
            
            Logger.log(
                "App Environment changed to \(currentAppEnvironment ?? "unknown")), clearing cache",
                level: .debug
            )
            
            Keys.allData.forEach {
                clearAllObjects(cacheKey: $0)
            }
        }
        
        // Save the current setting as the previous one
        defaults.set(currentAppEnvironment, forKey: Keys.previousAppEnvironmentKey)
    }
}
