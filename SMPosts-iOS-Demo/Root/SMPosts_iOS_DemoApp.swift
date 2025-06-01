//
//  SMPosts_iOS_DemoApp.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


// MARK: - Enums

enum AppEnvironment: String {
    case mock = "app_environment_mock"
    case real = "app_environment_real"
}


@main
struct SMPosts_iOS_DemoApp: App {

    // MARK: - Properties
    
    private let cacheService = CacheService.shared
    
    // MARK: - Getters
    
    private var environment: AppEnvironment {
        cacheService.appEnvironment
    }
    
    // MARK: - Life cycle

    init() {
        cacheService.clearCacheAtLaunchIfNeeded()
        cacheService.refreshAppEnvironmentIfNeeded()
    }
    
    // MARK: - UI

    var body: some Scene {
        
        WindowGroup {
            PostListView(
                appEnvironment: environment
            )
        }
    }
}
