//
//  ExpenseView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 30/06/2023.
//

import SwiftUI

struct ExpenseView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var showSheet = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.expenses) { expense in
                    HStack {
                        Text(expense.title)
                            .bold()
                        Spacer()
                        Text("\(expense.amount.formatted())")
                    }
                }
                .onDelete(perform: viewModel.removeExpenses)
            }
            .navigationBarTitle("Expenses")
            .toolbar {
                
                ToolbarItem {
                    Button {
                        if viewModel.categories.isEmpty {
                            showAlert.toggle()
                        } else {
                            showSheet.toggle()
                        }
                    } label: {
                        Text("Add")
                        Image(systemName: "cart.badge.plus")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        
                    } label: {
                        Text("All expenses")
                    }
                }
            }
        }
        .alert("There is no any category so please add at least one", isPresented: $showAlert) {
            Button("Ok", role: .cancel){
                
            }
        }
        .sheet(isPresented: $showSheet) {
            AddExpenseView()
        }
        
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.expenses = Constans.expenses
        return NavigationView {
            ExpenseView()
        }
        .environmentObject(viewModel)
    }
}
