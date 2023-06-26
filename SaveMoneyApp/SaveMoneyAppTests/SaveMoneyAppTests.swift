//
//  SaveMoneyAppTests.swift
//  SaveMoneyAppTests
//
//  Created by Marcin Dytko on 26/06/2023.
//

import XCTest
@testable import SaveMoneyApp


final class SaveMoneyAppTests: XCTestCase {


    func testRemoveCategory() {
    
        
        let viewModel = ViewModel()
        /// Given
        // Set up test data
        viewModel.categories = [ExpenseCategory(name: "Category1", id: UUID()),
                                ExpenseCategory(name: "Category2",  id: UUID()),
                                ExpenseCategory(name: "Category3",  id: UUID())]
        /// When
        // Index of "Category2" in the categories array
        let offsets = IndexSet(integer: 1)
        viewModel.removeCategory(at: offsets)
        /// Then
        // Check if the category is removed
        XCTAssertEqual(viewModel.categories.count, 2)
        // Check if the first category remains
        XCTAssertEqual(viewModel.categories[0].name, "Category1")
        // Check if the third category remains
        XCTAssertEqual(viewModel.categories[1].name, "Category3")
    }
}
