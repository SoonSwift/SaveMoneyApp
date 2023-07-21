//
//  Extension+View.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 26/06/2023.
//

import SwiftUI

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle()
                .frame(height: 2)
                .padding(.top, 35)
            )
            .foregroundColor(.blue)
            .padding(10)
    }
}
