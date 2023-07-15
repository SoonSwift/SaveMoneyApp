//
//  Constants.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import Foundation

struct Constans {
    static let categegories = [ExpenseCategory(name: "cos", id: UUID()), ExpenseCategory(name: "karma", id: UUID()), ExpenseCategory(name: "Dziewczyna", id: UUID())]
    static let categoryFileName = "categories.json"
    static let expenses = [Expense(id: UUID(), title: "hm", amount: 122.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now), Expense(id: UUID(), title: "food", amount: 12.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now)]
    static let expenseFileName = "expenses.json"
}
