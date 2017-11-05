//
//  ViewController.swift
//  MVC-Storyboard
//
//  Created by giftbot on 2017. 9. 30..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit
import SafariServices

final class RepositoriesViewController: BaseViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var indicatorView: UIActivityIndicatorView!
  
  private let gitHub = GitHubService()
  private var currentSetting = ServiceSetting.decode()
  private var repositories = [Repository]()
  
  // MARK: View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadData()
  }
  
  override func setupUI() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .mainColor
    refreshControl.addTarget(self, action: #selector(requestGitHubRepositories), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  // MARK: Action
  
  @IBAction func reloadData() {
    indicatorView.startAnimating()
    requestGitHubRepositories()
  }
  
  @objc private func requestGitHubRepositories() {
    gitHub.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let repositories):
          self.repositories = repositories
          self.tableView.reloadData()
        case .error(let error):
          let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(okAction)
          self.present(alertController, animated: true)
        }
        self.stopNetworking()
      }
    }
  }
  
  private func stopNetworking() {
    indicatorView.stopAnimating()
    tableView.refreshControl?.endRefreshing()
  }
  
  // MARK: Navigation
  
  @IBAction func editSetting() {
    let settingVC = SettingViewController.createWith(initialData: currentSetting) {
      [weak self] setting in
      guard let `self` = self, self.currentSetting != setting else { return }
      self.currentSetting = setting
      self.currentSetting.encoded()
      self.reloadData()
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
    let cell = tableView.dequeue(RepositoriesTableViewCell.self, for: indexPath)
    let repository = repositories[indexPath.row]
    cell.configureWith(name: repository.fullName,
                       description: repository.description,
                       star: repository.starCount,
                       fork: repository.forkCount)
    return cell
  }
}

