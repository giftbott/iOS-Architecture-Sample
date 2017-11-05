//
//  RepositoriesPresenter.swift
//  MVP-Code
//
//  Created by giftbot on 2017. 10. 6..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol RepositoriesPresenterType: class, PresenterType {
  weak var view: RepositoriesViewType! { get set }
  
  func reloadData()
  // TableView
  func didSelectTableViewRowAt(indexPath: IndexPath)
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: RepositoriesCellType, forRowAt indexPath: IndexPath)
  // Navigation
  func editSetting()
}

// MARK: - Class Implementation

final class RepositoriesPresenter {
  
  // MARK: Properties

  weak var view: RepositoriesViewType!
  
  private let gitHubService: GitHubServiceType
  private var currentSetting: ServiceSetting
  private var repositories = [Repository]()
  
  // MARK: Initialize
  
  init(service: GitHubServiceType = GitHubService(), serviceSetting: ServiceSetting) {
    gitHubService = service
    currentSetting = serviceSetting
  }
  
  // MARK: Life Cycle
  
  func onViewDidLoad() {
    reloadData()
  }
  
  // MARK: Action
  
  private func requestGitHubRepositories() {
    view.startNetworking()
    gitHubService.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let repositories):
          self.repositories = repositories
        case .error(let error):
          self.view.presentAlert(title: "Error", message: error.localizedDescription)
        }
        self.view.stopNetworking()
      }
    }
  }
}

// MARK: - RepositoriesPresenterType

extension RepositoriesPresenter: RepositoriesPresenterType {
  func reloadData() {
    requestGitHubRepositories()
  }
  
  // MARK: TableView
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    guard let url = URL(string: repository.url) else { return }
    view.showRepository(by: url)
  }
  
  func numberOfRows(in section: Int) -> Int {
    return repositories.count
  }
  
  func configureCell(_ cell: RepositoriesCellType, forRowAt indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    cell.configureWith(name: repository.fullName,
                       description: repository.description,
                       star: repository.starCount,
                       fork: repository.forkCount)
  }
  
  // MARK: Navigation
  
  func editSetting() {
    let settingPresenter = SettingPresenter(initialData: currentSetting) { [weak self] setting in
      guard let `self` = self, self.currentSetting != setting else { return }
      self.currentSetting = setting
      self.currentSetting.encoded()
      self.reloadData()
    }
    let settingVC = SettingViewController(presenter: settingPresenter)
    view.show(settingVC, animated: true)
  }
}
