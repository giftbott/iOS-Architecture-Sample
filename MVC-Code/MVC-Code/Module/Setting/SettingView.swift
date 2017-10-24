//
//  SettingView.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class SettingView: BaseView<SettingViewController> {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let tableViewFrame = UIScreen.main.bounds
    static let tableViewRowHeight = CGFloat(40)
    static let tableViewHeaderHeight = CGFloat(40)
    static let tableViewFooterHeight = CGFloat(0)
  }
  
  // MARK: Properties
  
  let tableView = UITableView(frame: UI.tableViewFrame, style: .grouped)
  
  // MARK: Initialize
  
  override func setupUI() {
    vc.navigationItem.title = "Setting"
    
    tableView.rowHeight = UI.tableViewRowHeight
    tableView.sectionHeaderHeight = UI.tableViewHeaderHeight
    tableView.sectionFooterHeight = UI.tableViewFooterHeight
    tableView.separatorColor = tableView.backgroundColor
    tableView.allowsMultipleSelection = true
    tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    addSubview(tableView)
  }
  
  override func setupBinding() {
    tableView.delegate = vc
    tableView.dataSource = vc
    
    let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save,
                                        target: vc,
                                        action: #selector(vc.saveCurrentSetting))
    vc.navigationItem.rightBarButtonItem = saveBarButton
  }
}
