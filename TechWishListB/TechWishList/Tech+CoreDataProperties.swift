//
//  Tech+CoreDataProperties.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//
import Foundation
import CoreData
extension Tech {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tech> {
        return NSFetchRequest<Tech>(entityName: "Tech")
    }
    @NSManaged public var photo: NSData?
    @NSManaged public var title: String?
    @NSManaged public var prefr: String?
    @NSManaged public var specs: String?
}
