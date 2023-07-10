//
//  PlotView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 10/07/2023.
//

import SwiftUI
import SwiftUICharts

struct PlotView: View {
    
    var demoData: [Double] = [8,2,4,6,12,9,2]
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Picker("Expanse tracker", selection: $viewModel.trackingMode) {
                ForEach(viewModel.trackingModes) { mode in
                    Text(mode.rawValue)
                        .tag(mode as ExpenseTrackingMode)
                }
            }
            LineChartView(data: viewModel.getAllExpenseAmounts(viewModel.getTrackedExpenses()), title: "Tracker")

        }
    }
}

struct PlotView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.expenses = Constans.expenses
        viewModel.categories = Constans.categegories
        return NavigationView {
            PlotView()
                .environmentObject(viewModel)

        }
    }
}
