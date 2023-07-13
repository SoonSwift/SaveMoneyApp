//
//  PlotView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 10/07/2023.
//

import SwiftUI
import SwiftUICharts

struct PlotView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Picker("Expanse tracker", selection: $viewModel.trackingMode) {
                ForEach(viewModel.trackingModes) { mode in
                    Text(mode.rawValue)
                        .tag(mode as ExpenseTrackingMode)
                }
            }
            if viewModel.getAllExpenseAmounts(viewModel.getTrackedExpenses()).isEmpty {
                
            } else {
                LineChartView(data: viewModel.getAllExpenseAmounts(viewModel.getTrackedExpenses()), title: "Tracker")
                
            }
            HStack {
                BarChartView(data: ChartData(points: viewModel.userPick()), title: "Expanses")
                
                BarChartView(data: ChartData(values: viewModel.getExpenseSumByCategory()), title: "Categories")
            }
        }
    }
    
}

struct PlotView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.expenses = [Expense(id: UUID(), title: "hm", amount: 122.2, category: ExpenseCategory(name: "karma", id: UUID()), date: viewModel.addOrSubtractMonth(month: -1)), Expense(id: UUID(), title: "food", amount: 12.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now)]
        viewModel.categories = Constans.categegories
        return NavigationView {
            PlotView()
                .environmentObject(viewModel)
        }
    }
 
}
