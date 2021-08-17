//
//  CatObject+CoreDataClass.swift
//  CatApp
//
//  Created by XO on 12.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CatObject)
public class CatObject: NSManagedObject {
    
    static func object(from model: Cat, in context: NSManagedObjectContext) -> CatObject? {
        guard let entityDescription = entity(in: context) else { return nil }
        let object = CatObject(entity: entityDescription, insertInto: context)
        
        object.id = model.id
        object.url = model.url
        object.width = Int32(model.width ?? 0)
        object.height = Int32(model.height ?? 0)
        
        return object
    }
}


