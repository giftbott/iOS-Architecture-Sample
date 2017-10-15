//
//  SettingTableViewCell.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol SettingCellType {
  func setTitleText(_ title: String)
}

// MARK: - Class Implementation

final class SettingTableViewCell: UITableViewCell, SettingCellType {
  
  // MARK: Properties
  
  static let identifier = String(describing: SettingTableViewCell.self)
  
  // MARK: Initialize
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure Selection
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      accessoryType = .checkmark
      textLabel?.font = .boldSystemFont(ofSize: 14)
      textLabel?.textColor = UIColor(red: 0, green: 0.44, blue: 1, alpha: 1)
    } else {
      accessoryType = .none
      textLabel?.font = .systemFont(ofSize: 13)
      textLabel?.textColor = .darkGray
    }
  }
  
  // MARK: Cell Contents
  
  func setTitleText(_ title: String) {
    textLabel?.text = title
  }
}

