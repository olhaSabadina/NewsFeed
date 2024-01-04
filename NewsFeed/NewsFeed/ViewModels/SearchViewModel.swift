//
//  SearchViewModel.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 29.12.2023.
//

import UIKit
import CoreData

final class SearchViewModel {
    
    let coreDataManager = CoreDataManager.instance
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    init() {
        setupFetchResultController(search: "")
    }
    
    func setupFetchResultController(search: String? = nil) {
        fetchResultController = coreDataManager.fetchSearchNews(sortName: #keyPath(RssItem.pubDate), filter: search)
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func cellConfigure(indexPath: IndexPath) -> RssItem? {
        let rssItem = fetchResultController.object(at: indexPath) as? RssItem
        return rssItem
    }
    
    func numberOfItemsInSection() -> Int {
        guard let sectionInfo = fetchResultController.sections?[0] else { return 0 }
        return sectionInfo.numberOfObjects
    }
}
