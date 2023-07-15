//
//  SettingsView.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 13/07/2023.
//

import SwiftUI
import StoreKit

enum SchameType: Int, Identifiable, CaseIterable {
    var id: Self {self}
    case system,light,dark
}

extension SchameType {
    var title: LocalizedStringKey {
        switch self {
        case .system:
            return "System"
        case .dark:
            return "Dark"
        case .light:
            return "Light"
        }
    }
}

struct SettingsView: View {
    @AppStorage("systemThemeVal") private var systemTheme:Int = SchameType.allCases.first!.rawValue
    @Environment(\.colorScheme) var colorScahme
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    private var email = SupportEmail(toAddress: "mar.dytko@gmail.com", subject: "Support Email", messageHeader: "Please describe your problem below")
    private let link = URL(string: "https://www.apple.com")!

    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Info")) {
                    VStack(alignment: .leading) {
                        Image("Logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This app was made by Marcin Dytko.")
                            .font(.callout)
                            .fontWeight(.medium)
                            
                    }
                    .padding(.vertical)
                    Picker(selection: $systemTheme) {
                        ForEach(SchameType.allCases) { item in
                            Text(item.title)
                                .tag(item.rawValue)
                        }
                    } label: {
                        Text("Color Mode:")
                    }
                    HStack {
                        Text("Version:")
                        Text(Bundle.main.getValue(forKey: .appVersion))
                    }
                    Link(LocalizedStringKey("Fallow on GitHub"), destination: URL(string: "https://github.com/SoonSwift")!)
                    Button("Review the app") {
                        requestReview()
                    }
                    ShareLink(item: URL(string: "https://www.apple.com")!) {
                        Label("Share App", systemImage: "square.and.arrow.up")
                    }
                    
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button() {
                        email.send(openURL: openURL)
                    } label: {
                        HStack {
                            Text("Support")
                            Image(systemName: "envelope.circle.fill")
                                .font(.title2)
                        }
                        
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
