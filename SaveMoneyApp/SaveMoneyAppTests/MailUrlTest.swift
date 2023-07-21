//
//  MailUrlTest.swift
//  SaveMoneyAppTests
//
//  Created by Marcin Dytko on 21/07/2023.
//

import XCTest
@testable import SaveMoneyApp

final class MailUrlTest: XCTestCase {
    
    private struct MailData {
        let name: String
        let subject: String
        let body: String?
        let expectedUrlString: String
    }
    
    func testKrzysztofUrl() {
        let dataToTest = [
            MailData(name: "Krzysztof", subject: "Temat", body: nil, expectedUrlString: "mailto:Krzysztof?subject=Temat&body="),
            MailData(name: "Marcin", subject: "Temat", body: "Coś mi się zepsuło", expectedUrlString: "mailto:Marcin?subject=Temat&body=Co%C5%9B%C2%A0mi%20si%C4%99%C2%A0zepsu%C5%82o")
        ]
        
        for data in dataToTest {
            let testUrl = MailUrlBuilder(toAddress: data.name, subject: data.subject, body: data.body).build()
            XCTAssertEqual(testUrl?.description, data.expectedUrlString)
        }
    }

}
