// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import Client

import XCTest

class MailProvidersTests: XCTestCase {
    let toEmail = "name1@test.com"
    let ccEmail = "name2@test.com"
    let bccEmail = "name3@test.com"
    let subject = "The%20subject%20of%20the%20email"
    let body = "The%20body%20of%20the%20email"

    // MARK: - Readdle Spark
    func testReaddleSparkIntegration_basicMetadata() {
        let provider = ReaddleSparkIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "readdle-spark://compose?recipient=\(toEmail)")
    }

    func testReaddleSparkIntegration_fullMetadata() {
        let provider = ReaddleSparkIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "readdle-spark://compose")
        XCTAssertEqual(mailURL.getQuery(),
                       ["recipient": toEmail, "subject": subject, "textbody": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - Airmail
    func testAirmailIntegration_basicMetadata() {
        let provider = AirmailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "airmail://compose?to=\(toEmail)")
    }

    func testAirmailSparkIntegration_fullMetadata() {
        let provider = AirmailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "airmail://compose")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "htmlBody": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - MyMail
    func testMyMailIntegration_basicMetadata() {
        let provider = MyMailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "mymail-mailto://?to=\(toEmail)")
    }

    func testMyMailIntegration_fullMetadata() {
        let provider = MyMailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "mymail-mailto://")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - MailRuIntegration
    func testMailRuIntegration_basicMetadata() {
        let provider = MailRuIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "mailru-mailto://?to=\(toEmail)")
    }

    func testMailRuIntegration_fullMetadata() {
        let provider = MailRuIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "mailru-mailto://")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - MS Outlook
    func testMSOutlookIntegration_basicMetadata() {
        let provider = MSOutlookIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "ms-outlook://emails/new?to=\(toEmail)")
    }

    func testMSOutlookIntegration_fullMetadata() {
        let provider = MSOutlookIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "ms-outlook://emails/new")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - YMail
    func testYMailIntegration_basicMetadata() {
        let provider = YMailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "ymail://mail/any/compose?to=\(toEmail)")
    }

    func testYMailIntegration_fullMetadata() {
        let provider = YMailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "ymail://mail/any/compose")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail])
    }

    // MARK: - Google Gmail
    func testGoogleGmailIntegration_basicMetadata() {
        let provider = GoogleGmailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "googlegmail:///co?to=\(toEmail)")
    }

    func testGoogleGmailIntegration_fullMetadata() {
        let provider = GoogleGmailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "googlegmail:///co")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - Fastmail
    func testFastmailIntegration_basicMetadata() {
        let provider = FastmailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "fastmail://mail/compose?to=\(toEmail)")
    }

    func testFastmailSparkIntegration_fullMetadata() {
        let provider = FastmailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "fastmail://mail/compose")
        XCTAssertEqual(mailURL.getQuery(),
                       ["to": toEmail, "subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - ProtonMail
    func testProtonMailIntegration_basicMetadata() {
        let provider = ProtonMailIntegration()
        let mailURL = provider.newEmailURLFromMetadata(buildBasicMetadata())
        XCTAssertEqual(mailURL?.absoluteString, "protonmail://mailto:\(toEmail)")
    }

    func testProtonMailSparkIntegration_fullMetadata() {
        let provider = ProtonMailIntegration()
        guard let mailURL = provider.newEmailURLFromMetadata(buildFullMetadata()) else {
            XCTFail("Email URL should be present")
            return
        }

        XCTAssertEqual(urlStringWithoutQuery(url: mailURL)!, "protonmail://mailto:\(toEmail)")
        XCTAssertEqual(mailURL.getQuery(),
                       ["subject": subject, "body": body, "cc": ccEmail, "bcc": bccEmail])
    }

    // MARK: - Private
    private func buildBasicMetadata() -> MailToMetadata {
        return MailToMetadata(to: toEmail, headers: [:])
    }

    private func buildFullMetadata() -> MailToMetadata {
        let headers = [ "subject": subject,
                        "body": body,
                        "cc": ccEmail,
                        "bcc": bccEmail]

        return MailToMetadata(to: toEmail, headers: headers)
    }

    private func urlStringWithoutQuery(url: URL) -> String? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = nil
        return components?.url?.absoluteDisplayString
    }
}
