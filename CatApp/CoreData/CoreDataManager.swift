//
//  CoreDataManager.swift
//  CatApp
//
//  Created by XO on 12.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    func getFetchResultsController(entityName: String, sortDescriptor: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let filter = filterKey {
            fetchRequest.predicate = NSPredicate(format: "id = %@", filter)
        }
        let fetcnhedResultVc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetcnhedResultVc
    }
    
    func checkSave(id: String) -> Bool {
        let fetchResultController = CoreDataManager.shared.getFetchResultsController(entityName: "CatObject", sortDescriptor: "id", filterKey: id)
        do { try fetchResultController.performFetch() } catch {
            print("can't performFetch")
            return false
        }
        return (fetchResultController.sections?[0].numberOfObjects == 1)
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CatApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(cat: Cat?) {
        guard let cat = cat else { return }
        _ = CatObject.object(from: cat, in: CoreDataManager.shared.persistentContainer.viewContext)
        CoreDataManager.shared.saveContext()
    }
    
    func remove(id: String) {
        let fetchRequestController: NSFetchedResultsController<CatObject>? = CoreDataManager.shared.getFetchResultsController(entityName: "CatObject", sortDescriptor: "id", filterKey: String(id)) as? NSFetchedResultsController<CatObject>
        do { try fetchRequestController?.performFetch() } catch let error as NSError {
            print(error.self)
            return }

        guard let catObject = fetchRequestController?.fetchedObjects?.first else { return }
        CoreDataManager.shared.persistentContainer.viewContext.delete(catObject)
        CoreDataManager.shared.saveContext()
    }
    
    func removeAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "\(CatObject.self)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? CoreDataManager.shared.persistentContainer.viewContext.execute(deleteRequest)
        CoreDataManager.shared.saveContext()
        
        let catFetchResultsController = CoreDataManager.shared.getFetchResultsController(entityName: "CatObject", sortDescriptor: "id", filterKey: nil)
        try? catFetchResultsController.performFetch()
    }
    
}
