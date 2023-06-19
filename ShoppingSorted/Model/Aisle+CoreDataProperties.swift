//
//  Aisle+CoreDataProperties.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/04/2023.
//
//

import Foundation
import CoreData


extension Aisle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Aisle> {
        return NSFetchRequest<Aisle>(entityName: "Aisle")
    }

    @NSManaged public var name: String?
    @NSManaged public var order: Int16

}

extension Aisle : Identifiable {

}
