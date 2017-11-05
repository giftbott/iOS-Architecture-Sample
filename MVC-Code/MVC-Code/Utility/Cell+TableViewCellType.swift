//
//  Cell+TableViewCellType.swift
//  MVVM-Rx
//
//  Created by giftbot on 2017. 11. 1..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol TableViewCellType {
  static var identifier: String { get }
}

extension UITableViewCell: TableViewCellType {
  static var identifier: String { return String(describing: self.self) }
}

extension UITableView {
  func register<Cell>(
    cell: Cell.Type,
    forCellReuseIdentifier reuseIdentifier: String = Cell.identifier
    ) where Cell: UITableViewCell {
    register(cell, forCellReuseIdentifier: reuseIdentifier)
  }
  
  func dequeue<Cell>(_ reusableCell: Cell.Type) -> Cell? where Cell: UITableViewCell {
    return dequeueReusableCell(withIdentifier: reusableCell.identifier) as? Cell
  }
}

