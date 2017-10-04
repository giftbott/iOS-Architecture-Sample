//
//  RepositoriesView.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class RepositoriesView: BaseView<RepositoriesViewController> {
  
  // MARK: Properties
		
  let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
  
  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let estimatedRowHeight = CGFloat(80)
  }
  
  // MARK: Setup
  
  override func setupUI() {
    // navigation
    vc.navigationItem.title = "Repository List"
    
    // tableView
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .mainColor
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = UI.estimatedRowHeight
    tableView.separatorColor = .mainColor
    tableView.separatorInset = UIEdgeInsetsMake(0, UI.baseMargin, 0, UI.baseMargin)
    tableView.register(RepositoriesTableViewCell.self,
                       forCellReuseIdentifier: RepositoriesTableViewCell.identifier)
    addSubview(tableView)
  }
  
  override func setupBinding() {
    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: vc, action: #selector(vc.requestGitHubRepositories))
    vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: vc, action: #selector(vc.editSetting))
    
    tableView.delegate = vc
    tableView.dataSource = vc
    tableView.refreshControl?.addTarget(vc, action: #selector(vc.refreshData), for: .valueChanged)
  }
  
}
