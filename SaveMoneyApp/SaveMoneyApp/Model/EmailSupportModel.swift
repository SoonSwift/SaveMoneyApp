//
//  EmailSupportModel.swift
//  SaveMoneyApp
//
//  Created by Marcin Dytko on 13/07/2023.
//

import Foundation
import SwiftUI

struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String { """
Application Name: \(Bundle.main.getValue(forKey: .displayName))
iOS: \(UIDevice.current.systemVersion)
Device Model: \(UIDevice.current.modelName)
App Version: \(Bundle.main.getValue(forKey: .appVersion))
App Build \(Bundle.main.getValue(forKey: .appBuild))
\(messageHeader)
---------------------------------------------
"""
    }
    
    func send(openURL: OpenURLAction) {
        guard let url = MailUrlBuilder(toAddress: toAddress,
                                          subject: subject,
                                          body: body).build() else { return }
        
        openURL(url) { accepted in
            guard !accepted else { return }
            print("""
                This device does not support email
                \(body)
            """)
        }
    }
}

struct MailUrlBuilder {
    let toAddress: String
    let subject: String
    let body: String?
    
    func build() -> URL? {
        URL(string: "mailto:\(toAddress)?subject=\(buildSubject())&body=\(buildBody())")
    }
    
    private func buildSubject() -> String {
        subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    private func buildBody() -> String {
        body?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}
