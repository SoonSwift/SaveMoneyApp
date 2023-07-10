//
//  ViewModel.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import Foundation

enum ExpenseTrackingMode: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case monthly = "Monthly"
    case all = "All"
    
    var id: String { self.rawValue }
}

class ViewModel: ObservableObject {
    
    @Published var expenses: [Expense] = []
    @Published var categories: [ExpenseCategory] = []
    @Published var trackingMode: ExpenseTrackingMode = .all
    
    var trackingModes: [ExpenseTrackingMode] {
            ExpenseTrackingMode.allCases
        }

    init() {
        loadCategoryFromFile()
        loadExpenseFromFile()
    }
    
    func removeExpenses(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveExpenseToFile()
    }
    
    func removeCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        saveCategoryToFile()
    }
    
    func saveCategoryToFile() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(categories)
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.categoryFileName)
            try data.write(to: fileUrl)
            print("Categories wass saved succesful")
        } catch {
            print("we cant save file \(error.localizedDescription)")
        }
    }
    
    func loadCategoryFromFile() {
        let fileManager = FileManager.default
        let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.categoryFileName)
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let loadedCategories = try decoder.decode([ExpenseCategory].self, from: data)
            categories = loadedCategories
        } catch {
            print("Failed to load file: \(error.localizedDescription)")
        }
    }
    
    func saveExpenseToFile() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(expenses)
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.expenseFileName)
            try data.write(to: fileUrl)
            print("Expanse was saved succesful")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadExpenseFromFile() {
        let fileManager = FileManager.default
        let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constans.expenseFileName)
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let loadedCategories = try decoder.decode([Expense].self, from: data)
            expenses = loadedCategories
        } catch {
            print("Failed to load file: \(error.localizedDescription)")
        }
    }
    
    func getAllExpenseAmounts(_ expenses: [Expense]) -> [Double] {
        guard !expenses.isEmpty else { return [] }
        let amounts = expenses.map { $0.amount }
        return amounts
    }
    
    func getTrackedExpenses() -> [Expense] {
        switch trackingMode {
        case .daily:
            return getDailyExpenses()
        case .monthly:
            return getMonthlyExpenses()
        case .all:
            return expenses
        }
    }
    
    private func getDailyExpenses() -> [Expense] {
        let today = Calendar.current.startOfDay(for: Date())
        let filteredExpenses = expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        return filteredExpenses
    }
    
    private func getMonthlyExpenses() -> [Expense] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let filteredExpenses = expenses.filter {
            let expenseMonth = Calendar.current.component(.month, from: $0.date)
            let expenseYear = Calendar.current.component(.year, from: $0.date)
            return expenseMonth == currentMonth && expenseYear == currentYear
        }
        return filteredExpenses
    }
    
}
