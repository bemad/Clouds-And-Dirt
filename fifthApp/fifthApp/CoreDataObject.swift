//
//  CoreDataStack.swift
//  fifthApp
//
//  Created by Bhavya Madan on 01/03/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//
import Foundation
import CoreData
struct CoreDataObject {
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let dbURL: URL
    internal let persistingContext: NSManagedObjectContext
    internal let backgroundContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    static let shared = CoreDataObject(modelName: "fifthApp")!
    init?(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        let fm = FileManager.default
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach the documents folder")
            return nil
        }
        self.dbURL = docUrl.appendingPathComponent("fifthApp.sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store at \(dbURL)")
        }
    }
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
    func save() {
        context.performAndWait() {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError("Error while saving main context: \(error)")
                }
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }    
}
