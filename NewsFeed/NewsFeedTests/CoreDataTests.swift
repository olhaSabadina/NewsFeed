//
//  CoreDataTests.swift
//  NewsFeedTests
//
//  Created by Olga Sabadina on 02.01.2024.
//

import XCTest
import CoreData
@testable import NewsFeed

final class CoreDataTests: XCTestCase {
    
    var sut: CoreDataManager!

    override func setUp() {
        super.setUp()
        sut = CoreDataManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateSaveAndGetRssItemFromCoreData() {
        let rssModel = RSSModel(channelName: "TestChannel", timeAppearance: Date(), newsTitle: "Test title frrd news", urlLink: "www.feedTestLink.com", typeCell: 0)
        sut.createRssItem(rssModel)
        
        let rssItemsFromStorage = sut.getRSSFromCore()
        XCTAssertEqual("Test title frrd news", rssItemsFromStorage[0].newsTitle)
        XCTAssertEqual("TestChannel", rssItemsFromStorage[0].nameChannel)
    }
    
    func testDeleteAllRssItemsInStorage() {
        var rssItemsFromStorage = sut.getRSSFromCore()
        
        XCTAssert(rssItemsFromStorage.isEmpty)
        
        let rssModel = RSSModel(channelName: "TestChannel", timeAppearance: Date(), newsTitle: "Test title frrd news", urlLink: "www.feedTestLink.com", typeCell: 0)
        sut.createRssItem(rssModel)
        rssItemsFromStorage = sut.getRSSFromCore()
        
        XCTAssertFalse(rssItemsFromStorage.isEmpty)
        
        sut.deleteAllRssItems()
        rssItemsFromStorage = sut.getRSSFromCore()
        
        XCTAssert(rssItemsFromStorage.isEmpty)
    }

}
