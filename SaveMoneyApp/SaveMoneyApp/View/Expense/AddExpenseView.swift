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
    @State private var amount: Double?
    @State private var amountString: String = ""
    @State private var selectedCategory: ExpenseCategory?
    @State private var isNecessary = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("Name of expense")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Informations")) {
                    TextField("Cost", text: $amountString)
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: amountString) { newValue in
                            amount = Double(newValue)
                        }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name)
                                .tag(category as ExpenseCategory?)
                        }
                    }
                    Toggle("Was it necessary expanse?", isOn: $isNecessary)
                }
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        let newExpanse = Expense(id: UUID(), title: name, amount: amount!, category: selectedCategory!, date: date, isNecessary: isNecessary)
                        viewModel.expenses.append(newExpanse)
                        viewModel.saveExpenseToFile()
                        dismiss()
                    }
                    .disabled(amount == nil || name.isEmpty)
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
