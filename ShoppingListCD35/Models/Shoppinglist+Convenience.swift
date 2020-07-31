//
//  Shoppinglist+Convenience.swift
//  ShoppingListCD35
//
//  Created by Alex Lundquist on 7/31/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import CoreData

extension List {
  convenience init(item: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
    self.init(context: context)
    self.item = item
    self.isComplete = isComplete
  }
}
