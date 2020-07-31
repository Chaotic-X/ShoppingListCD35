//
//  ShoppingListController.swift
//  ShoppingListCD35
//
//  Created by Alex Lundquist on 7/31/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
  
  //MARK: -Shared Instance - Singleton
  static let shared = ShoppingListController()
  
  //MARK: -Source of Truth
  let fetchResultsController: NSFetchedResultsController<List> = {
    let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
    let completeSort = NSSortDescriptor(key: "isComplete", ascending: true)
    fetchRequest.sortDescriptors = [completeSort]
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath:"isComplete", cacheName: nil)
  }() // End Source of Truth
  
  init(){
    do{
      try fetchResultsController.performFetch()
    } catch {
      print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    }
  } //End ShoppingListController Initilizer
  
  //MARK: -CRUD
  //create
  func createItem(newItem item: String) {
    _ = List(item: item)
    //Save
    saveToPersistentStore()
  } //End Create
  
  //Read - Not this week
  
  //Update
  func upDateToggle(listItem: List) {
    listItem.isComplete.toggle()
    //save
    saveToPersistentStore()
  } //End Update
  
  //Delete
  func deleteItem(itemToDelete item: List) {
    let moc = CoreDataStack.context
    moc.delete(item)
    //save
    saveToPersistentStore()
  } //End delete
  
  //MARK: -Persistent Store
  func saveToPersistentStore(){
    do{
      try CoreDataStack.context.save()
    }catch {
      print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    }
  } //End Save
} //End of Class
