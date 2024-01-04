//
//  SavedVCViewModel.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 18.12.2023.
//

import UIKit
import CoreData

final class SavedVCViewModel {

    private let coreDataManager = CoreDataManager.instance
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    init() {
        setupFetchResultController()
    }
    
    func setupFetchResultController() {
        fetchResultController = coreDataManager.fetchResultController(sortName: #keyPath(RssItem.pubDate))
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func removeFromFavourites(_ rssItem: RssItem?) {
        CoreDataManager.instance.addToFavorites(rssItem)
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
