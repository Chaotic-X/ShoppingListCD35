//
//  ShoppingListTableViewController.swift
//  ShoppingListCD35
//
//  Created by Alex Lundquist on 7/31/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ShoppingListController.shared.fetchResultsController.delegate = self
    
  }
  
  //MARK: -ACtions
  @IBAction func addItemButtonTapped(_ sender: Any) {
    presentAlertController()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return ShoppingListController.shared.fetchResultsController.sections?.count ?? 0
  } //End of Section Number

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ShoppingListController.shared.fetchResultsController.sections?[section].numberOfObjects ?? 0
  } //End of Number of Rows in Section
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ShoppingListController.shared.fetchResultsController.sectionIndexTitles[section] == "0" ? "Keep Looking For it" : "Complete"
  } //End of Section Title
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }
    let listItemToDisplay = ShoppingListController.shared.fetchResultsController.object(at: indexPath)
    cell.listItem = listItemToDisplay
    cell.delegate = self
    return cell
  } //End of Cell Configuration

  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let itemToDelete = ShoppingListController.shared.fetchResultsController.object(at: indexPath)
      ShoppingListController.shared.deleteItem(itemToDelete: itemToDelete)
    }
  } // End of Delete Item from Table
  
  //MARK: -AlertController
  func presentAlertController(){
    let alertController = UIAlertController(title: "Add Item to Shopping list", message: nil, preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.placeholder = "Enter item here"
      textField.textAlignment = .center
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    let addAcction = UIAlertAction(title: "Add Item", style: .default) { (_) in
      guard let listItem = alertController.textFields?[0].text, !listItem.isEmpty else { self.missingInfoAlertController(); return }
      ShoppingListController.shared.createItem(newItem: listItem)
    }
    alertController.addAction(addAcction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  func missingInfoAlertController() {
    let alertController = UIAlertController(title: "MISSING INFO", message: "List Item can't be left empty", preferredStyle: .alert)
    let continueAction = UIAlertAction(title: "Continue", style: .default) { (_) in
      self.presentAlertController()
    }
    alertController.addAction(continueAction)
    present(alertController, animated: true)
  }

} //End of Class

//MARK: -Extensions
extension ShoppingListTableViewController: ShoppingListTableViewCellDelegate {
  func isCompleteButtonTappedStatus(_ sender: ShoppingListTableViewCell) {
    guard let indexPath = tableView.indexPath(for: sender) else { return }
    let listItem = ShoppingListController.shared.fetchResultsController.object(at: indexPath)
    ShoppingListController.shared.upDateToggle(listItem: listItem)
    sender.updateCell()
  }
} //End of Cell Delegate exention

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
      case .insert:
        let indexSet = IndexSet(integer: sectionIndex)
        tableView.insertSections(indexSet, with: .automatic)
      case .delete:
        let indexSet = IndexSet(integer: sectionIndex)
        tableView.deleteSections(indexSet, with: .automatic)
      default:
        fatalError()
    }
  }
 
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
      case .delete:
        guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
      case .insert:
        guard let newIndexPath = newIndexPath else { break }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      case .move:
        guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
        tableView.moveRow(at: indexPath, to: newIndexPath)
      case .update:
        guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .automatic)
      @unknown default:
        fatalError()
    }
  }
} //End of NSFetchedResults Delegate
