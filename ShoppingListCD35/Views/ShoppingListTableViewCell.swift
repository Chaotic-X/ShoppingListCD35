//
//  ShoppingListTableViewCell.swift
//  ShoppingListCD35
//
//  Created by Alex Lundquist on 7/31/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit

//MARK: -Protocols
protocol ShoppingListTableViewCellDelegate: class {
  func isCompleteButtonTappedStatus(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var itemLabel: UILabel!
  @IBOutlet weak var isCompleteButton: UIButton!
  
  //MARK: -Properties
  var listItem: List? {
    didSet {
      updateCell()
    }
  }
  //MARK: -Delegate
  weak var delegate: ShoppingListTableViewCellDelegate?
  
  //MARK: -Actions
  @IBAction func isCompleteButtonTapped(_ sender: Any) {
    delegate?.isCompleteButtonTappedStatus(self)
  }
  
  //MARK: -Cell Setup
  func updateCell() {
    guard let listItem = listItem else { return }
    itemLabel.text = listItem.item
    updateIsCompleteButton(for: listItem)
  }
  
  //MARK: -Helper Functions
  func updateIsCompleteButton(for listItem: List) {
    let checkSymbolConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .bold, scale: .large)
    let squareSymbolConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .bold, scale: .large)
    let completeImage = UIImage(systemName: "checkmark.square" , withConfiguration: checkSymbolConfig)
    let inCompleteImage = UIImage(systemName: "square", withConfiguration: squareSymbolConfig)
    listItem.isComplete ? isCompleteButton.setImage(completeImage, for: .normal) : isCompleteButton.setImage(inCompleteImage, for: .normal)
  }
}
