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
        let category2 = ExpenseCategory(name: "Category 2", id: UUID())
        
        viewModel.categories = [category1, category2]
        
        let expense1 = Expense(id: UUID(), title: "expanse1", amount: 40.34, category: category1, date: Date(), isNecessary: true)
        let expense2 = Expense(id: UUID(), title: "expanse2", amount: 21.32, category: category1, date: Date(), isNecessary: false)
        let expense3 = Expense(id: UUID(), title: "expanse3", amount: 56.23, category: category2, date: Date(), isNecessary: false)
        
        viewModel.expenses = [expense1, expense2, expense3]
        
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertEqual(viewModel.expenses.count, 3)
        
        // When
        viewModel.removeCategory(at: IndexSet([0]))
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 1) // Category 1 should be removed
        XCTAssertEqual(viewModel.expenses.count, 1) // expense1 and expense2 should be removed
        XCTAssertEqual(viewModel.categories.first?.name, "Category 2")
    }
    
    func testCategorySaveToFile() {
        // Given
        let viewModel = ViewModel()
        viewModel.categories = [ExpenseCategory(name: "Category 1",id: UUID()), ExpenseCategory(name: "Category 2", id: UUID())]
        
        // When
        viewModel.saveCategoryToFile()
        
        // Then
        let fileUrl = FileHelper.fileURL(for: Constans.categoryFileName)
        XCTAssertTrue(FileHelper.fileExists(at: fileUrl))
        
        if let decodedCategories = FileHelper.loadData([ExpenseCategory].self, from: fileUrl) {
            XCTAssertEqual(decodedCategories, viewModel.categories)
        } else {
            XCTFail("Failed to decode categories from file")
        }
    }
    
    func testLoadCategoryFromFile() {
        // Given
        let viewModel = ViewModel()
        
        // Create a test file with sample categories
        let categories = [ExpenseCategory(name: "Category 1", id: UUID()), ExpenseCategory(name: "Category 2", id: UUID())]
        let fileUrl = FileHelper.fileURL(for: Constans.categoryFileName)
        FileHelper.saveData(categories, to: fileUrl)
        
        // When
        viewModel.loadCategoryFromFile()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == "Category 1" }))
        XCTAssertTrue(viewModel.categories.contains(where: { $0.name == "Category 2" }))
    }
    
    func testExpenseSaveToFile() {
        // Given
        let viewModel = ViewModel()
        viewModel.expenses = [Expense(id: UUID(), title: "Burger", amount: 14.3, category: ExpenseCategory(name: "Food", id: UUID()), date: Date.now), Expense(id: UUID(), title: "Bed", amount: 1000.0, category: ExpenseCategory(name: "Personal", id: UUID()), date: Date.now)]
        
        // When
        viewModel.saveExpenseToFile()
        
        // Then
        let fileUrl = FileHelper.fileURL(for: Constans.expenseFileName)
        XCTAssertTrue(FileHelper.fileExists(at: fileUrl))
        
        if let decodedExpenses = FileHelper.loadData([Expense].self, from: fileUrl) {
            XCTAssertEqual(decodedExpenses, viewModel.expenses)
        } else {
            XCTFail("Failed to decode expenses from file")
        }
    }
    
    func testLoadExpanseFromFile() {
        // Given
        let viewModel = ViewModel()
        
        // Create a test file with sample expenses
        let expenses = [
            Expense(id: UUID(), title: "hm", amount: 12.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now),
            Expense(id: UUID(), title: "food", amount: 12.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now)
        ]
        let fileUrl = FileHelper.fileURL(for: Constans.expenseFileName)
        FileHelper.saveData(expenses, to: fileUrl)
        
        // When
        viewModel.loadExpenseFromFile()
        
        // Then
        XCTAssertEqual(viewModel.expenses.count, 2)
        XCTAssertEqual(viewModel.expenses[0].title, "hm")
        XCTAssertEqual(viewModel.expenses[1].title, "food")
    }
    
    func testGetAllExpenseAmounts() {
        // Given
        let viewModel = ViewModel()
        let expenses = [
            Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: Date()),
            Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "xd", id: UUID()), date: Date()),
            Expense(id: UUID(), title: "Expense 3", amount: 15.75, category: ExpenseCategory(name: "da", id: UUID()), date: Date())
        ]
        
        // When
        let amounts = viewModel.getAllExpenseAmounts(expenses)
        
        // Then
        XCTAssertEqual(amounts.count, expenses.count)
        XCTAssertEqual(amounts, [10.5, 20.0, 15.75])
    }
    
    func testRemoveExpense() {
        // Given
        let viewModel = ViewModel()
        let expense1 = Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: Date())
        let expense2 = Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "sleep", id: UUID()), date: Date())
        let expense3 = Expense(id: UUID(), title: "Expense 3", amount: 30.0, category: ExpenseCategory(name: "It's ok", id: UUID()), date: Date())
        viewModel.expenses = [expense1, expense2, expense3]
        
        // When
        viewModel.removeExpenses(at: IndexSet(integer: 1))
        
        // Then
        XCTAssertEqual(viewModel.expenses.count, 2)
        XCTAssertEqual(viewModel.expenses, [expense1, expense3])
    }
    
    func testGetTrackedExpense() {
        // Given
        let viewModel = ViewModel()
        viewModel.trackingMode = .daily
        let currentDate = Date()
        
        // Create a date component for 25 hours ago
        var dateComponents = DateComponents()
        dateComponents.hour = -25
        
        // Calculate the date 25 hours ago
        let calendar = Calendar.current
        if let date25HoursAgo = calendar.date(byAdding: dateComponents, to: currentDate) {
            // Create the expense with the date set to 25 hours ago
            let expense1 = Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: date25HoursAgo)
            let expense2 = Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "sleep", id: UUID()), date: Date())
            let expense3 = Expense(id: UUID(), title: "Expense 3", amount: 30.0, category: ExpenseCategory(name: "It's ok", id: UUID()), date: Date())
            viewModel.expenses = [expense1, expense2, expense3]
            print("Expense 1 Date: \(expense1.date)")
        } else {
            XCTFail("Failed to calculate the date 25 hours ago")
        }
        
        // When
        let array = viewModel.getTrackedExpenses()
        
        // Then
        XCTAssertEqual(array.count, 2)
    }
    
    func testGetExpensesSumByDay() {
        // Given
        let viewModel = ViewModel()
        viewModel.trackingMode = .daily
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.hour = -25
        
        let calendar = Calendar.current
        if let date25HoursAgo = calendar.date(byAdding: dateComponents, to: currentDate) {
            // Create the expense with the date set to 25 hours ago
            let expense1 = Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: date25HoursAgo)
            let expense2 = Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "sleep", id: UUID()), date: Date())
            let expense3 = Expense(id: UUID(), title: "Expense 3", amount: 30.0, category: ExpenseCategory(name: "It's ok", id: UUID()), date: Date())
            viewModel.expenses = [expense1, expense2, expense3]
            print("Expense 1 Date: \(expense1.date)")
        } else {
            print("Failed to calculate the date 25 hours ago")
        }
        
        // When
        let sum = viewModel.getExpensesSumByDay()
        
        // Then
        // Sum shuld be always equal to 1
        XCTAssertEqual(sum.count, 1)
        XCTAssert(sum[0] == 50.0)
    }
    
    func testGetTotalExpensesSum() {
        // Given
        let viewModel = ViewModel()
        viewModel.trackingMode = .all
        
        var dateComponents = DateComponents()
        dateComponents.hour = -25
        let currentDate = Date()
        
        let calendar = Calendar.current
        if let date25HoursAgo = calendar.date(byAdding: dateComponents, to: currentDate) {
            // Create the expense with the date set to 25 hours ago
            let expense1 = Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: date25HoursAgo)
            let expense2 = Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "sleep", id: UUID()), date: Date())
            let expense3 = Expense(id: UUID(), title: "Expense 3", amount: 30.0, category: ExpenseCategory(name: "It's ok", id: UUID()), date: Date())
            viewModel.expenses = [expense1, expense2, expense3]
            print("Expense 1 Date: \(expense1.date)")
        } else {
            print("Failed to calculate the date 25 hours ago")
        }
        
        // When
        let sumOfAll = viewModel.getTotalExpensesSum()
        
        // Then
        XCTAssertEqual(sumOfAll.count, 1)
        XCTAssert(sumOfAll[0] == 60.5)
    }
    
    func testGetExpenseSumByCategory() {
        // Given
        let viewModel = ViewModel()
        viewModel.trackingMode = .daily
        
        var dateComponents = DateComponents()
        dateComponents.hour = -25
        let currentDate = Date()
        
        let calendar = Calendar.current
        if let date25HoursAgo = calendar.date(byAdding: dateComponents, to: currentDate) {
            // Create the expense with the date set to 25 hours ago
            let expense1 = Expense(id: UUID(), title: "Expense 1", amount: 10.5, category: ExpenseCategory(name: "da", id: UUID()), date: date25HoursAgo)
            let expense2 = Expense(id: UUID(), title: "Expense 2", amount: 20.0, category: ExpenseCategory(name: "sleep", id: UUID()), date: Date())
            let expense3 = Expense(id: UUID(), title: "Expense 3", amount: 30.0, category: ExpenseCategory(name: "It's ok", id: UUID()), date: Date())
            viewModel.expenses = [expense1, expense2, expense3]
            print("Expense 1 Date: \(expense1.date)")
        } else {
            print("Failed to calculate the date 25 hours ago")
        }
        
        // When
        let sumByCategory = viewModel.getExpenseSumByCategory()
        
        // Then
        XCTAssert(sumByCategory.count == 2)
        // Sort the dictionary by category name
        XCTAssertEqual(sumByCategory[0].0, "It's ok")
        XCTAssertEqual(sumByCategory[1].0, "sleep")
    }
    
}
