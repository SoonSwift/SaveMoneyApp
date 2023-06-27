//
//  AddCategoryView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var isSheetShowing = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.categories) { category in
                        Text(category.name)
                    }
                    .onDelete(perform: viewModel.removeCategory)
                }
            }
            .sheet(isPresented: $isSheetShowing) {
                AddCategoryView()
                    .presentationDetents([.height(300)])
            }
            
            .navigationTitle("Category")
            .toolbar {
                ToolbarItem() {
                    Button {
                        isSheetShowing.toggle()
                    } label: {
                        Image(systemName: "plus")
                        Text("Add")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    EditButton()
                }
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.categories = Constans.categegories
        
        return  NavigationView {
            CategoryListView()
        }
            .environmentObject(viewModel)
    }
}
