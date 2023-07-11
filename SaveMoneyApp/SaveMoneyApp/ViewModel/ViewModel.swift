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
        var expensesSumByDay: [Double] = Array(repeating: 0.0, count: 31) // Assuming max 31 days in a month
        
        for expense in dailyExpenses {
            let calendar = Calendar.current
            let expenseDay = calendar.component(.day, from: expense.date)
            expensesSumByDay[expenseDay - 1] += expense.amount
        }
        
        return expensesSumByDay
    }
    
    func getExpensesSumByMonth() -> [Double] {
        let monthlyExpenses = getTrackedExpenses()
        var expensesSumByMonth: [Double] = Array(repeating: 0.0, count: 12) // Assuming 12 months in a year
        
        for expense in monthlyExpenses {
            let calendar = Calendar.current
            let expenseMonth = calendar.component(.month, from: expense.date)
            expensesSumByMonth[expenseMonth - 1] += expense.amount
        }
        
        return expensesSumByMonth
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

}
