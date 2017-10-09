//
//  RepositoriesPresenter.swift
//  MVP-Code
//
//  Created by giftbot on 2017. 10. 6..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

// MARK: - Protocol

typealias RepositoriesPresenterType = RepositoriesPresenterNonObjcType & RepositoriesPresenterObjcType

protocol RepositoriesPresenterNonObjcType: class, BasePresenterType {
  weak var view: RepositoriesViewType! { get set }
  var repositories: [Repository] { get }
  func didSelectTableViewRowAt(indexPath: IndexPath)
}
@objc protocol RepositoriesPresenterObjcType: class {
  func editSetting()
  func pullToRefresh()
  func reloadData()
}


// MARK: - Class Implementation

final class RepositoriesPresenter {
  
  // MARK: Properties
  
  weak var view: RepositoriesViewType!
  var repositories = [Repository]()
  
  private let gitHub: GitHubService
  private var currentSetting: ServiceSetting
  
  // MARK: Initialize
  
  init(service: GitHubService = GitHubService(), serviceSetting: ServiceSetting = ServiceSetting()) {
    gitHub = service
    currentSetting = serviceSetting
  }
  
  // MARK: Life Cycle
  
  func onViewDidLoad() {
    reloadData()
  }
  
  // MARK: Action
  
  private func requestGitHubRepositories() {
    gitHub.fetchGitHubRepositories(by: currentSetting) { [weak self] result in
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
  
  func pullToRefresh() {
    requestGitHubRepositories()
  }
  
  func reloadData() {
    view.startNetworking()
    requestGitHubRepositories()
  }
  
  // Navigation
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    guard let url = URL(string: repository.url) else { return }
    view.showRepository(by: url)
  }
  
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
