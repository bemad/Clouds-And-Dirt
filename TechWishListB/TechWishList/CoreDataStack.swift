//
//  CoreDataStack.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import CoreData
struct CoreDataStack {
    static func sharedInstance() -> CoreDataStack {
        struct Singleton {
            static let instance = CoreDataStack(modelName: "TechWishList")
        }
        return Singleton.instance!
    }
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let databaseURL: URL
    let managedObjectContext: NSManagedObjectContext
    init?(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find model")
            return nil
        }
        self.modelURL = modelURL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("model creation error")
            return nil
        }
        self.model = model
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        let fm = FileManager.default
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach documents.")
            return nil
        }
        self.databaseURL = docUrl.appendingPathComponent("TechWishList.sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: databaseURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store")
        }
    }
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: databaseURL, options: nil)
    }
}
internal extension CoreDataStack  {
    func dropAllData() throws {
        try coordinator.destroyPersistentStore(at: databaseURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: databaseURL, options: nil)
    }
}
extension CoreDataStack {
    func saveContext () {
        let context = self.managedObjectContext
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let savingError as NSError {
                error = savingError
                NSLog("Unresolved error \(error!), \(error!.userInfo)")
                abort()
            }
        }
    }
}
