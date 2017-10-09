//
//  ViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit
import SafariServices

// MARK: - Protocol

protocol RepositoriesViewType: BaseViewType {
  func presentAlert(title: String, message: String)
  func show(_ viewController: UIViewController, animated: Bool)
  func showRepository(by url: URL)
  func startNetworking()
  func stopNetworking()
}

// MARK: - Class Implentation

final class RepositoriesViewController: BaseViewController {
  
  // MARK: Properties
  
  private let presenter: RepositoriesPresenterType
  private let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let estimatedRowHeight = CGFloat(80)
  }
  
  // MARK: Initialize
  
  init(presenter: RepositoriesPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    presenter.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: presenter, action: #selector(presenter.reloadData))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: presenter, action: #selector(presenter.editSetting))
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl?.addTarget(presenter, action: #selector(presenter.pullToRefresh), for: .valueChanged)
  }
}

// MARK: - RepositoriesViewType

extension RepositoriesViewController: RepositoriesViewType {

  // Alert
  
  func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true)
  }
  
  // Navigation

  func show(_ viewController: UIViewController, animated: Bool) {
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  func showRepository(by url: URL) {
    let safariViewController = SFSafariViewController(url: url)
    navigationController?.pushViewController(safariViewController, animated: true)
  }
  
  // Networking
  
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
    return presenter.repositories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseId = String(describing: RepositoriesTableViewCell.self)
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! RepositoriesTableViewCell
    
    let repository = presenter.repositories[indexPath.row]
    cell.configureWith(name: repository.fullName,
                       description: repository.description,
                       star: repository.starCount,
                       fork: repository.forkCount)
    return cell
  }
}

