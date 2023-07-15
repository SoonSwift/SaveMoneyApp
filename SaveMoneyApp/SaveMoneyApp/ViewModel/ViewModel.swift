//
//  ViewModel.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import Foundation

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
    
    func getExpensesSumByDay() -> [Double] {
        let dailyExpenses = getTrackedExpenses()
        let calendar = Calendar.current
        let currentDate = Date()
        
        var expensesSumToday: Double = 0.0
        
        for expense in dailyExpenses {
            if calendar.isDate(expense.date, inSameDayAs: currentDate) {
                expensesSumToday += expense.amount
            }
        }
        
        return [expensesSumToday]
    }
    
    func getExpensesSumByMonth() -> [Double] {
        let monthlyExpenses = getTrackedExpenses()
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        
        var expensesSumByMonth: Double = 0.0
        
        for expense in monthlyExpenses {
            let expenseMonth = calendar.component(.month, from: expense.date)
            if expenseMonth == currentMonth {
                expensesSumByMonth += expense.amount
            }
        }
        
        return [expensesSumByMonth]
    }

    func getTotalExpensesSum() -> [Double] {
        let allExpenses = getTrackedExpenses()
        let totalSum = allExpenses.reduce(0.0) { $0 + $1.amount }
        return [totalSum]
    }
    
    func userPick() -> [Double] {
        switch trackingMode {
        case .daily:
            return getExpensesSumByDay()
        case .monthly:
            return getExpensesSumByMonth()
        case .all:
            return getTotalExpensesSum()
        }
    }
    
    func addOrSubtractMonth(month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }
    
    func getExpenseSumByCategory() -> [(String, Double)] {
        let trackedExpenses = getTrackedExpenses()
        var sumByCategory: [String: Double] = [:]
        
        for expense in trackedExpenses {
            let category = expense.category.name
            if let sum = sumByCategory[category] {
                sumByCategory[category] = sum + expense.amount
            } else {
                sumByCategory[category] = expense.amount
            }
        }
        // Sort the dictionary by category name and extract the values as an array of tuples
        let sortedSumByCategory = sumByCategory.sorted { $0.key < $1.key }
        let sums = sortedSumByCategory.map { ($0.key, $0.value) }
        return sums
    }
    
    func getTotalNecessaryExpenses() -> Double {
        let trackedExpenses = getTrackedExpenses()
        let necessaryExpenses = trackedExpenses.filter { $0.isNecessary }
        let totalSum = necessaryExpenses.reduce(0.0) { $0 + $1.amount }
        return totalSum
    }
    
    func getTotalNonNecessaryExpenses() -> Double {
        let trackedExpenses = getTrackedExpenses()
        let nonNecessaryExpenses = trackedExpenses.filter { !$0.isNecessary }
        let totalSum = nonNecessaryExpenses.reduce(0.0) { $0 + $1.amount }
        return totalSum
    }

}
