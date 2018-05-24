//
//  Tech+CoreDataClass.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import CoreData
@objc(Tech)
public class Tech: NSManagedObject {
    convenience init(title: String, specs: String, prefr: String, photo: NSData, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Tech", in: context) {
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.specs = specs
            self.prefr = prefr
            self.photo = photo
        } else {
            fatalError("Unable to find entity name!")
        }
    }
}
