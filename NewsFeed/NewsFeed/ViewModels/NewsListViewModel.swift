//
//  NewsListViewModel.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 14.12.2023.
//
import Combine
import UIKit
import FeedKit

enum InternetConnectionType {
    case disconnect
    case isConnected
    
    var message: String {
        switch self {
        case .disconnect:
            return "There is no internet connection, check your settings."
        case .isConnected:
            return "An Internet connection appeared. Do you want to refresh news?"
        }
    }
}

final class NewsListViewModel {
    
    @Published var channels = [RssItem]()
    @Published var isLoading = false
    @Published var showAlert: InternetConnectionType = .isConnected
    @Published var error: Error?
    private let coreDataManager = CoreDataManager.instance
    private let networkManager = NetworkManager()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchAllRssNews()
    }
    
    func fetchAllRssNews() {
        isLoading = true
        var resultArr = [RssItem]()
        getAllRssFeeds(urlStrings: RssSourse.arraysURL)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.channels = self.coreDataManager.getRSSFromCore()
                    self.isLoading = false
                case .failure(let err):
                    self.showAlert = .disconnect
                    self.error = err
                    self.channels = self.coreDataManager.getRSSFromCore()
                    self.isLoading = false
                }
            } receiveValue: { feeds in
                self.coreDataManager.deleteAllRssItems()
                feeds.forEach{ item in
                    resultArr.append(contentsOf: self.parseRssItemAndSaveCD(item, cellType: self.getIndex(item)))
                }
            }
            .store(in: &cancellable)
    }
    
    func numberOfItemsInSection() -> Int {
        return channels.count
    }
    
    private func parseRssItemAndSaveCD(_ rssFeed: RSSFeed, cellType: Int) -> [RssItem] {
        
        guard let rssItems = rssFeed.items else { return  [] }
        var array = [RssItem]()
        let nameChanel = rssFeed.title ?? ""
        
        rssItems.forEach { item in
            let pubDate = item.pubDate ?? Date()
            let title = item.title ?? ""
            let description = item.description ?? ""
            let link = item.link ?? ""
            let image = item.media?.mediaContents?.first?.attributes?.url ?? ""
            
            let rssModel = RSSModel(channelName: nameChanel, timeAppearance: pubDate, newsTitle: title, newsShortDescription: description, image: image, urlLink: link, typeCell: cellType)
            
            array.append(coreDataManager.createRssItem(rssModel))
        }
        return array
    }
    
    private func getAllRssFeeds(urlStrings: [String]) -> AnyPublisher<[RSSFeed], Error> {
        let publishers: [AnyPublisher<RSSFeed, Error>] = urlStrings.map(loadRssNewsFromSource)
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func loadRssNewsFromSource(urlString: String) -> AnyPublisher<RSSFeed, Error> {
        return Future<RSSFeed, Error> { promise in
            self.networkManager.loadRSSFeed(urlString: urlString) { result in
                switch result {
                case .success(let feed):
                    guard let rssFeed = feed.rssFeed else {
                        promise(.failure(NetworkErrors.invalidFeed))
                        return
                    }
                    promise(.success(rssFeed))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getIndex(_ rssFeed: RSSFeed) -> Int {
        guard let link = rssFeed.link else { return 0 }
        
        if link == RssSourse.ycombinator.link {
            return 0
        } else if link == RssSourse.foxnews.link {
            return 1
        } else if link == RssSourse.aljazeera.link {
            return 2
        }
        return 0
    }
}



