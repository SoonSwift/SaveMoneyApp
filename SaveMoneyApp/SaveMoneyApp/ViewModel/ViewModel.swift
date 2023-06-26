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
    
    func removeCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }
}
