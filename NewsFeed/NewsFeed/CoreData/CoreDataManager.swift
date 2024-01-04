//
//  CoreDataManager.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 18.12.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    lazy var context = persistentContainer.viewContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NewsFeed")
        persistentContainer.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    //Init for tests
    init(_ test: String? = nil) {
        persistentContainer = NSPersistentContainer(name: "NewsFeed")
        persistentContainer.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
    }
    
    //Return Name Currencys from CoreData which are displayed in the main table
    func getRSSFromCore() -> [RssItem] {
        var allRssItems: [RssItem] = []
        let fetchRequest = NSFetchRequest<RssItem>(entityName: "RssItem")
        
        let sortDescriptorToPubDate = NSSortDescriptor(key: #keyPath(RssItem.pubDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptorToPubDate]
        
        do{
            allRssItems = try context.fetch(fetchRequest)
        } catch {
            print("not fetch users")
        }
        
        return allRssItems
    }
    
    //Create RssItem entity from RSSModel and save in CoreData
    func createBackGroundRssItem(_ rssModel: RSSModel) async -> RssItem? {
        let backgroundContext = persistentContainer.newBackgroundContext()
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        do {
            return try await backgroundContext.perform {
                let newRssItem = RssItem(context: backgroundContext)
                newRssItem.nameChannel = rssModel.channelName
                newRssItem.pubDate = rssModel.timePosts
                newRssItem.newsTitle = rssModel.newsTitle
                newRssItem.newsDescription = rssModel.newsDescription
                newRssItem.urlLink = rssModel.urlLink
                newRssItem.imageUrl = rssModel.newsImage
                newRssItem.typeCell = Int16(rssModel.typeCell)
                try backgroundContext.save()
                return newRssItem
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    func createRssItem(_ rssModel: RSSModel) -> RssItem {
        let newRssItem = RssItem(context: context)
        newRssItem.nameChannel = rssModel.channelName
        newRssItem.pubDate = rssModel.timePosts
        newRssItem.newsTitle = rssModel.newsTitle
        newRssItem.newsDescription = rssModel.newsDescription
        newRssItem.urlLink = rssModel.urlLink
        newRssItem.imageUrl = rssModel.newsImage
        newRssItem.typeCell = Int16(rssModel.typeCell)
        saveContext()
        return newRssItem
    }
    
    //Delete CurrencyCore
    func deleteAllRssItems(){
        let fetchRequest = NSFetchRequest<RssItem>(entityName: "RssItem")
        let predicate = NSPredicate(format: "isFavourite = %@", NSNumber(value: false))
        fetchRequest.predicate = predicate
        do{
            let allRssItems = try context.fetch(fetchRequest)
            allRssItems.forEach{
                if !$0.isFavourite {
                    context.delete($0)
                }
            }
            saveContext()
        } catch {
            print("not fetch users")
        }
    }
    
    func addToFavorites(_ rssItem: RssItem?) {
        rssItem?.isFavourite.toggle()
        saveContext()
    }
    
    func fetchResultController(sortName: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RssItem")
        
        let sortDescriptor = NSSortDescriptor(key: sortName, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    func fetchSearchNews(sortName: String, filter: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RssItem")
        
        let sortDescriptor = NSSortDescriptor(key: sortName, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "(newsTitle contains[cd] %@) OR (newsDescription contains[cd] %@)" , filter, filter.lowercased())
            fetchRequest.predicate = predicate
        }
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



