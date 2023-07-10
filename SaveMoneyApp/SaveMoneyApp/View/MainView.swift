//
//  ContentView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import SwiftUI

struct MainView: View {
    
    
    @State private var selection = 0
    
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
                            Image(systemName: "plus.forwardslash.minus")
                            Text("Category")
                        }
                    }
                    .tag(1)
                
                PlotView()
                    .tabItem {
                        VStack {
                            Image(systemName: "plus.forwardslash.minus")
                            Text("Category")
                        }
                    }
                    .tag(2)
            }
        }
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
