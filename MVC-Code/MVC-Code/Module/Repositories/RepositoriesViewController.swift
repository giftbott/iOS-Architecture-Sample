//
//  ViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit
import SafariServices

final class RepositoriesViewController: BaseViewController, ViewBindable {
  
  // MARK: Properties
  
  var v: RepositoriesView!
  private weak var tableView: UITableView!
  
  private let gitHub = GitHubService()
  private var currentSetting = ServiceSetting()
  fileprivate var repositories = [Repository]()
  
  
  // MARK: View LifeCycle
  
  override func loadView() {
    bindView(withViewController: self)
    tableView = v.tableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requestGitHubRepositories()
  }
  
  // MARK: Action
  
  func requestGitHubRepositories() {
    gitHub.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
      guard let `self` = self else { return }
      
      switch result {
      case .success(let json):
        self.repositories = json.flatMap { Repository(json: $0) }
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case .error(let error):
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
      }
      self.tableView.refreshControl?.endRefreshing()
    }
  }
  
  func refreshData() {
    tableView.refreshControl?.beginRefreshing()
    requestGitHubRepositories()
  }
  
  // MARK: Navigation
  
  func editSetting() {
    let settingVC = SettingViewController(initialData: currentSetting) {
      [weak self] setting in
      self?.currentSetting = setting
      self?.requestGitHubRepositories()
    }
    navigationController?.pushViewController(settingVC, animated: true)
  }
}

// MARK: - Configure TableView

extension RepositoriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    guard let url = URL(string: repository.url) else { return }
    
    let safariViewController = SFSafariViewController(url: url)
    navigationController?.pushViewController(safariViewController, animated: true)
  }
}

extension RepositoriesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseId = String(describing: RepositoriesTableViewCell.self)
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! RepositoriesTableViewCell
    
    let repository = repositories[indexPath.row]
    cell.configureWith(name: repository.fullName,
                       description: repository.description,
                       star: repository.starCount,
                       fork: repository.forkCount)
    return cell
  }
}
