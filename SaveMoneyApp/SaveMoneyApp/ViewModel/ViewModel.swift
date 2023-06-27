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
    
    init() {
        loadCategoryFromFile()
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
    
}
