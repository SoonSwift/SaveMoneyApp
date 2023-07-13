//
//  Bundle+Extension.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 13/07/2023.
//

import SwiftUI

enum BundleKey: String {
    case displayName = "CFBundleName"
    case appBuild = "CFBundleVersion"
    case appVersion = "CFBundleShortVersionString"
}

extension Bundle {
    func getValue(forKey key: BundleKey) -> String {
        object(forInfoDictionaryKey: key.rawValue) as? String ?? "Could not determine the application version"
    }
    
    func getData(from fileName: String) -> Data? {
        guard let url = url(forResource: fileName, withExtension: nil) else {
            fatalError("Error: Failed to locate \(fileName) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Error: Failed to load \(fileName) from bundle.")
        }
        
        return data
    }
}
