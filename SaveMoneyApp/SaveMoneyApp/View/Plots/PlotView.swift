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
        NavigationView {
            VStack {
                Picker("Expanse tracker", selection: $viewModel.trackingMode) {
                    ForEach(viewModel.trackingModes) { mode in
                        Text(mode.rawValue)
                            .tag(mode as ExpenseTrackingMode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 20)
                Spacer()
                if viewModel.getAllExpenseAmounts(viewModel.getTrackedExpenses()).isEmpty {
                    Text("We dont have information to show please add expense")
                } else {
                    HStack {
                        LineChartView(data: viewModel.getAllExpenseAmounts(viewModel.getTrackedExpenses()), title: "Tracker")
                        BarChartView(data: ChartData(values: [("Necessary", viewModel.getTotalNecessaryExpenses()), ("Not necessary", viewModel.getTotalNonNecessaryExpenses())]), title: "Necessary Expense")
                        
                    }
                    HStack {
                        BarChartView(data: ChartData(points: viewModel.userPick()), title: "Expanses")
                        
                        BarChartView(data: ChartData(values: viewModel.getExpenseSumByCategory()), title: "Categories")
                    }
                }
                Spacer()
            }
            .navigationTitle("Plots")
        }
    }
}

struct PlotView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.expenses = [Expense(id: UUID(), title: "hm", amount: 122.2, category: ExpenseCategory(name: "karma", id: UUID()), date: viewModel.addOrSubtractMonth(month: -1)), Expense(id: UUID(), title: "food", amount: 12.2, category: ExpenseCategory(name: "karma", id: UUID()), date: Date.now)]
        viewModel.categories = Constans.categegories
       
        return PlotView()
                .environmentObject(viewModel)
        
    }
 
}
