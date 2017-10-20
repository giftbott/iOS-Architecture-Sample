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

final class RepositoriesViewController: BaseViewController {
  
  // MARK: Properties
  
  var presenter: RepositoriesPresenterProtocol!
  private let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let estimatedRowHeight = CGFloat(80)
  }
  
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
    tableView.register(RepositoriesTableViewCell.self,
                       forCellReuseIdentifier: RepositoriesTableViewCell.identifier)
    
    indicatorView.color = .mainColor
    indicatorView.center = view.center
    
    view.addSubviews([tableView, indicatorView])
  }
  
  override func setupBinding() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapLeftBarButtonItem))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: self, action: #selector(didTapRightBarButtonItem))
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl?.addTarget(self, action: #selector(didPulltoRefresh), for: .valueChanged)
  }
  
  // MARK: Target Action
  
  @objc func didTapLeftBarButtonItem() {
    presenter.reloadData()
  }
  
  @objc func didTapRightBarButtonItem() {
    presenter.editSetting()
  }
  
  @objc func didPulltoRefresh() {
    presenter.pullToRefresh()
  }
}

// MARK: - RepositoriesViewProtocol

extension RepositoriesViewController: RepositoriesViewProtocol {
  
  func startNetworking() {
    indicatorView.startAnimating()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesTableViewCell.identifier) as! RepositoriesTableViewCell
    presenter.configureCell(cell, forRowAt: indexPath)
    return cell
  }
}
