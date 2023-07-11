//
//  Models.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import Foundation

struct Expense: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let amount: Double
    var category: ExpenseCategory
    let date: Date
}

struct ExpenseCategory: Identifiable, Codable, Equatable, Hashable {
    let name: String
    let id: UUID
}

enum ExpenseTrackingMode: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case monthly = "Monthly"
    case all = "All"
    var id: String { self.rawValue }
}
