//
//  SMPosts_iOS_DemoApp.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


enum AppEnvironment {
    case mock
    case real
}


@main
struct SMPosts_iOS_DemoApp: App {
    
    private var environment: AppEnvironment = .real
    
    var body: some Scene {
        
        WindowGroup {
            PostListView(appEnvironment: environment)
        }
    }
}
