//
//  ViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit
import SafariServices

final class RepositoriesViewController: BaseViewController {
  
  // MARK: Properties
  
  lazy var v = RepositoriesView(controlBy: self)
  
  private let gitHubService: GitHubServiceType
  private var currentSetting: ServiceSetting
  private var repositories = [Repository]()
  
  // MARK: Initialize
  
  init(service: GitHubServiceType = GitHubService(), serviceSetting: ServiceSetting) {
    gitHubService = service
    currentSetting = serviceSetting
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View LifeCycle
  
  override func loadView() {
    view = v
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadData()
  }
  
  // MARK: Action
  
  @objc func reloadData() {
    requestGitHubRepositories()
  }
  
  private func requestGitHubRepositories() {
    v.startNetworking()
    gitHubService.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let repositories):
          self.repositories = repositories
        case .error(let error):
          let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(okAction)
          self.present(alertController, animated: true)
        }
        self.v.stopNetworking()
      }
    }
  }
  
  // MARK: Navigation
  
  @objc func editSetting() {
    let settingVC = SettingViewController(initialData: currentSetting) { [weak self] setting in
      guard let `self` = self, self.currentSetting != setting else { return }
      self.currentSetting = setting
      self.currentSetting.encoded()
      self.reloadData()
    }
    navigationController?.pushViewController(settingVC, animated: true)
  }
}

// MARK: - TableViewDelegate

extension RepositoriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    guard let url = URL(string: repository.url) else { return }
    
    let safariViewController = SFSafariViewController(url: url)
    navigationController?.pushViewController(safariViewController, animated: true)
  }
}

// MARK: - TableViewDataSource

extension RepositoriesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(RepositoriesTableViewCell.self)!
    let repository = repositories[indexPath.row]
    cell.configureWith(name: repository.fullName,
                       description: repository.description,
                       star: repository.starCount,
                       fork: repository.forkCount)
    return cell
  }
}
