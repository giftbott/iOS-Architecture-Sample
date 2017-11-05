//
//  RepositoriesView.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class RepositoriesView: BaseView<RepositoriesViewController> {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let tableViewFrame = UIScreen.main.bounds
    static let estimatedRowHeight = CGFloat(80)
  }
  
  // MARK: Properties
		
  let tableView = UITableView(frame: UI.tableViewFrame, style: .plain)
  let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // MARK: Setup
  
  override func setupUI() {
    vc.navigationItem.title = "Repository List"
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .mainColor
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = UI.estimatedRowHeight
    tableView.separatorColor = .mainColor
    tableView.separatorInset = UIEdgeInsetsMake(0, UI.baseMargin, 0, UI.baseMargin)
    tableView.register(cell: RepositoriesTableViewCell.self)
    
    indicatorView.color = .mainColor
    indicatorView.center = center
    
    addSubviews([tableView, indicatorView])
  }
  
  override func setupBinding() {
    tableView.delegate = vc
    tableView.dataSource = vc
    tableView.refreshControl?.addTarget(vc, action: #selector(vc.reloadData), for: .valueChanged)
    
    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh, target: vc, action: #selector(vc.reloadData)
    )
    vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: vc, action: #selector(vc.editSetting)
    )
  }
  
  // MARK: Action
  
  func startNetworking() {
    if !tableView.refreshControl!.isRefreshing {
      indicatorView.startAnimating()
    }
  }
  
  func stopNetworking() {
    indicatorView.stopAnimating()
    tableView.refreshControl?.endRefreshing()
    tableView.reloadData()
  }
}
