//
//  AddCategoryView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import SwiftUI

struct AddCategoryView: View {
    
    @State private var name = ""
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("Add Category")
                        .font(.title2)
                    HStack {
                        Image(systemName: "pencil")
                        TextField("Add Your Own Category", text: $name)
                    }
                    .underlineTextField()
                }
            }
            .padding()
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancle", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
            AddCategoryView()
    }
}
