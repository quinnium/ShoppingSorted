//
//  Unit+CoreDataProperties.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/04/2023.
//
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    @NSManaged public var name: String?
    @NSManaged public var order: Int16

}

extension Unit : Identifiable {

}
