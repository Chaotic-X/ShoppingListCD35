//
//  CoreDataStack.swift
//  ShoppingListCD35
//
//  Created by Alex Lundquist on 7/31/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  static let container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ShoppingListCD35")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved Error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  static var context: NSManagedObjectContext { return container.viewContext }
}
