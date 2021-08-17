//
//  NSManagedObject+Extension.swift
//  CatApp
//
//  Created by XO on 16.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func entity(in context: NSManagedObjectContext) -> NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context)
    }
}
