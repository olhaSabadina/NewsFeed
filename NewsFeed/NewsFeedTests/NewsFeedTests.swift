//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by Olga Sabadina on 12.12.2023.
//
import FeedKit
import XCTest
@testable import NewsFeed

final class NewsFeedTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNetworkManager() {
        
        //Given
        var expectedResult: RSSFeed?
        let expectation = expectation(description: "fetch feeds from Internet")
        
        //When
        sut.loadRSSFeed(urlString: RssSourse.foxnews.urlString) { result in
            switch result {
            case .success(let feed):
                expectedResult = feed.rssFeed
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 10)
        
        //Then
        XCTAssertNotNil(expectedResult)
        XCTAssertEqual("https://www.foxnews.com/", expectedResult?.link)
    }
}
