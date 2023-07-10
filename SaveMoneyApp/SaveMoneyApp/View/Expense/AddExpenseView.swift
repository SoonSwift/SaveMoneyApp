//
//  AddExpenseView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 30/06/2023.
//

import SwiftUI

struct AddExpenseView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var name = ""
    @State private var date = Date.now
    @State private var amount = 0.0
    @State private var selectedCategory: ExpenseCategory?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Name of expense")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Informations")) {
                    TextField("Cost", value: $amount, formatter: NumberFormatter())
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name)
                                .tag(category as ExpenseCategory?)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        let newExpanse = Expense(id: UUID(), title: name, amount: amount, category: selectedCategory!, date: date)
                        viewModel.expenses.append(newExpanse)
                        viewModel.saveExpenseToFile()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Canel") {
                        dismiss()
                    }
                }
                
            }
        }
        .onAppear {
            selectedCategory = viewModel.categories.first
        }
        
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.expenses = Constans.expenses
        viewModel.categories = Constans.categegories
        return NavigationView {
            AddExpenseView()
                .environmentObject(viewModel)

        }
        
    }
}
