//
//  FileManger.swift
//  SaveMoneyAppTests
//
//  Created by Marcin Dytko on 21/07/2023.
//

import Foundation

final class FileHelper {

    static func fileURL(for fileName: String) -> URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent(fileName)
    }

    static func saveData<T: Encodable>(_ data: T, to fileURL: URL) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            try encodedData.write(to: fileURL)
        } catch {
            fatalError("Failed to save data to file: \(error.localizedDescription)")
        }
    }

    static func loadData<T: Decodable>(_ type: T.Type, from fileURL: URL) -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to load data from file: \(error.localizedDescription)")
        }
    }

    static func fileExists(at fileURL: URL) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: fileURL.path)
    }

}
