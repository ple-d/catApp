//
//  CatObject+CoreDataProperties.swift
//  CatApp
//
//  Created by XO on 12.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//
//

import Foundation
import CoreData


extension CatObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatObject> {
        return NSFetchRequest<CatObject>(entityName: "CatObject")
    }

    @NSManaged public var height: Int32
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var width: Int32

}
