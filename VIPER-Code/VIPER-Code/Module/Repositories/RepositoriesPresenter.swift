//
//  RepositoriesPresenter.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

protocol RepositoriesPresenterProtocol: class, BasePresenterProtocol {
  // View -> Presenter

  func pullToRefresh()
  func reloadData()
  // TableView
  func configureCell(_ cell: RepositoriesCellType, forRowAt indexPath: IndexPath)
  func didSelectTableViewRowAt(indexPath: IndexPath)
  func numberOfRows(in section: Int) -> Int
  // Navigation
  func editSetting()
}

protocol RepositoriesInteractorOutputProtocol: class {
  // Interactor -> Presenter
  func setRepositories(_ repositories: [Repository])
  func didReceivedError(_ error: Error)
}

final class RepositoriesPresenter {
  // MARK: Properties
  weak var view: RepositoriesViewProtocol!
  private let wireframe: RepositoriesWireframeProtocol
  private let interactor: RepositoriesInteractorInputProtocol

  private var repositories = [Repository]()
  
  // MARK: Initialize
  
  init(view: RepositoriesViewProtocol,
       wireframe: RepositoriesWireframeProtocol,
       interactor: RepositoriesInteractorInputProtocol) {
    self.view = view
    self.wireframe = wireframe
    self.interactor = interactor
  }
}

// MARK: - PresenterProtocol
extension RepositoriesPresenter: RepositoriesPresenterProtocol {
  func onViewDidLoad() {
    interactor.requestRepositoriesData()
  }
  
  func pullToRefresh() {
    interactor.requestRepositoriesData()
  }
  
  func reloadData() {
    view.startNetworking()
    interactor.requestRepositoriesData()
  }
  
  // MARK: TableView
  
  func didSelectTableViewRowAt(indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    guard let url = URL(string: repository.url) else { return }
    wireframe.navigate(to: .repository(url: url))
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
    wireframe.navigate(to: .editSetting(interactor.currentSetting, completion: { [weak self] setting in
      guard let `self` = self, self.interactor.currentSetting != setting else { return }
      self.interactor.changeServiceSetting(to: setting)
      self.reloadData()
    }))
  }
}

// MARK: - InteractorOutputProtocol
extension RepositoriesPresenter: RepositoriesInteractorOutputProtocol {
  func setRepositories(_ repositories: [Repository]) {
    self.repositories = repositories
    view.stopNetworking()
  }
  
  func didReceivedError(_ error: Error) {
    wireframe.navigate(to: .alert(title: "Error", message: error.localizedDescription))
    view.stopNetworking()
  }
}

