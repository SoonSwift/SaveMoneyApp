//
//  SaveMoneyAppTests.swift
//  SaveMoneyAppTests
//
//  Created by Marcin Dytko on 26/06/2023.
//

import XCTest
@testable import SaveMoneyApp


final class CategoryTests: XCTestCase {


    func testRemoveCategory() {
        // Given
        let viewModel = ViewModel()
        let category1 = ExpenseCategory(name: "Category 1", id: UUID())
        let category2 = ExpenseCategory(name: "Category 2",id: UUID())
        viewModel.categories = [category1, category2]
        
        // When
        viewModel.removeCategory(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 1)
        XCTAssertFalse(viewModel.categories.contains(category1))
        
        // Verify that changes are saved to file
        let fileManager = FileManager.default
        let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.categoryFileName)
    
        XCTAssertTrue(fileManager.fileExists(atPath: fileUrl.path))
        
        if let data = try? Data(contentsOf: fileUrl) {
            let decoder = JSONDecoder()
            if let decodedCategories = try? decoder.decode([ExpenseCategory].self, from: data) {
                XCTAssertEqual(decodedCategories.count, 1)
                XCTAssertFalse(decodedCategories.contains(category1))
            } else {
                XCTFail("Failed to decode categories from file")
            }
        } else {
            XCTFail("Failed to read data from file")
        }
    }
    
    func testSaveToFile() {
        // Given
        let viewModel = ViewModel()
        viewModel.categories = [ExpenseCategory(name: "Category 1",id: UUID()), ExpenseCategory(name: "Category 2", id: UUID())]

        // When
        viewModel.saveCategoryToFile()
        
        // Then
        let fileManager = FileManager.default
        let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.categoryFileName)
        
        // Check if the file exists
        XCTAssertTrue(fileManager.fileExists(atPath: fileUrl.path))
        
        // Read the file
        if let data = try? Data(contentsOf: fileUrl) {
            // Decode the file contents
            let decoder = JSONDecoder()
            if let decodedCategories = try? decoder.decode([ExpenseCategory].self, from: data) {
                // Check if the decoded categories match the original categories
                XCTAssertEqual(decodedCategories, viewModel.categories)
            } else {
                XCTFail("Failed to decode categories from file")
            }
        } else {
            XCTFail("Failed to read data from file")
        }
    }

    func testloadCategoryFromFile() {
        // Given
        let viewModel = ViewModel()
        
        // Create a test file with sample categories
        let fileManager = FileManager.default
        let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.categoryFileName)
        let categories = [ExpenseCategory(name: "Category 1", id: UUID()), ExpenseCategory(name: "Category 2", id: UUID())]
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(categories)
            try data.write(to: fileUrl)
        } catch {
            XCTFail("Failed to create test file: \(error.localizedDescription)")
        }
        // When
        viewModel.loadCategoryFromFile()
            
        // Then
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == "Category 1" }))
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == "Category 2" }))
       
    }
}
