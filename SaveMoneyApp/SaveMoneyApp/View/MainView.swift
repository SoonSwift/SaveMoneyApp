//
//  ContentView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection = 0
    @AppStorage("systemThemeVal") private var systemTheme:Int = SchameType.allCases.first!.rawValue

    private var selectedSchame: ColorScheme? {
        guard let theme = SchameType(rawValue: systemTheme) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            
            TabView(selection: $selection) {
                CategoryListView()
                    .tabItem {
                        VStack {
                            Image(systemName: "plus.forwardslash.minus")
                            Text("Category")
                        }
                    }
                    .tag(0)
                
                ExpenseView()
                    .tabItem {
                        VStack {
                            Image(systemName: "equal.square.fill")
                            Text("Expense")
                        }
                    }
                    .tag(1)
                
                PlotView()
                    .tabItem {
                        VStack {
                            Image(systemName: "chart.xyaxis.line")
                            Text("Plots")
                        }
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                    .tag(3)
            }
           
        }
        .preferredColorScheme(selectedSchame)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.categories = Constans.categegories
        
        return MainView()
            .environmentObject(viewModel)
    }
}
