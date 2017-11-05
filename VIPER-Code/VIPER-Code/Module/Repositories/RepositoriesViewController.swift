//
//  RepositoriesViewController.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol RepositoriesViewProtocol: class {
  // Presenter -> View
  func startNetworking()
  func stopNetworking()
}

// MARK: - Class Implementation

final class RepositoriesViewController: BaseViewController {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let tableViewFrame = UIScreen.main.bounds
    static let estimatedRowHeight = CGFloat(80)
  }
  
  // MARK: Properties
  
  var presenter: RepositoriesPresenterProtocol!
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .plain)
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

  // MARK: View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.onViewDidLoad()
  }
  
  override func setupUI() {
    navigationItem.title = "Repository List"
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .mainColor
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = UI.estimatedRowHeight
    tableView.separatorColor = .mainColor
    tableView.separatorInset = UIEdgeInsetsMake(0, UI.baseMargin, 0, UI.baseMargin)
    tableView.register(cell: RepositoriesTableViewCell.self)
    
    indicatorView.color = .mainColor
    indicatorView.center = view.center
    
    view.addSubviews([tableView, indicatorView])
  }
  
  override func setupBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl?.addTarget(self, action: #selector(didPulltoRefresh), for: .valueChanged)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh, target: self, action: #selector(didTapLeftBarButtonItem)
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: self, action: #selector(didTapRightBarButtonItem)
    )
  }
  
  // MARK: Target Action
  
  @objc func didPulltoRefresh() {
    presenter.reloadData()
  }
  
  @objc func didTapLeftBarButtonItem() {
    presenter.reloadData()
  }
  
  @objc func didTapRightBarButtonItem() {
    presenter.editSetting()
  }
}

// MARK: - RepositoriesViewProtocol

extension RepositoriesViewController: RepositoriesViewProtocol {
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

// MARK: - Configure TableView

extension RepositoriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectTableViewRowAt(indexPath: indexPath)
  }
}

extension RepositoriesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(RepositoriesTableViewCell.self)!
    presenter.configureCell(cell, forRowAt: indexPath)
    return cell
  }
}
