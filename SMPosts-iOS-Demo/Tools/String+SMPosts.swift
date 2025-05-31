//
//  String+SMPosts.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 31/05/2025.
//

import Foundation


extension String {
    
    func capitalizedFirstLetter() -> String {
        let stringWithCapitalFirstCharacter = prefix(1).capitalized + dropFirst()
        return stringWithCapitalFirstCharacter
    }
}
