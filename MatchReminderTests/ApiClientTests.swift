//
//  ApiClientTests.swift
//  MatchReminderTests
//
//  Created by Lionel Smith on 08/08/2021.
//

import XCTest
@testable import MatchReminder

class ApiClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchMatches() {
        let expect = expectation(description: "fetch matches")
        let apiClient = ApiClient(session: MockNetworkSession(), resourcePath: "competitions/PL/matches")
        apiClient.fetchResource { (result: Result<MatchesResponse, ApiError>) in
            expect.fulfill()
            switch result {
            case .success(let matchesResponse):
                XCTAssertNotNil(matchesResponse.matches)
                XCTAssertEqual(matchesResponse.matches.count, 3)
            case .failure(let error):
                XCTAssertNil(error)
                XCTFail("Could not fetch matches")
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

}
