//
//  SettingPresenter.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol SettingPresenterProtocol: class, BasePresenterProtocol {
  // View -> Presenter
  var sectionHeaders: [String] { get }
  
  func didSelectTableViewRow(at indexPath: IndexPath)
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath?
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath)
  func saveCurrentSetting()
}

protocol SettingInteractorOutputProtocol: class {
  // Interactor -> Presenter
}

// MARK: - Class Implementation

final class SettingPresenter {

  // MARK: Properties
  
  private weak var view: SettingViewProtocol!
  private let wireframe: SettingWireframeProtocol
  private let interactor: SettingInteractorInputProtocol
  private var saveActionHandler: (ServiceSetting) -> ()
  
  lazy var sectionHeaders = interactor.settingHeaders
  
  // MARK: Initialize
  
  init(view: SettingViewProtocol,
       wireframe: SettingWireframeProtocol,
       interactor: SettingInteractorInputProtocol,
       completion: @escaping (ServiceSetting)->()) {
    self.view = view
    self.wireframe = wireframe
    self.interactor = interactor
    saveActionHandler = completion
  }
}

// MARK: - SettingPresenterProtocol

extension SettingPresenter: SettingPresenterProtocol {
  func saveCurrentSetting() {
    saveActionHandler(interactor.currentSetting)
    wireframe.popViewController(animated: true)
  }
  
  // MARK: TableView Handler
  
  func didSelectTableViewRow(at indexPath: IndexPath) {
    interactor.setServiceSettingForValue(at: indexPath)
  }
  
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath? {
    guard let selectedIndexPaths = selectedRows else { return nil }
    for selectedIndexPath in selectedIndexPaths {
      if selectedIndexPath.section == indexPath.section {
        view.determineTalbeViewRowSelection(willSelect: false, indexPath: selectedIndexPath, animated: false)
      }
    }
    return indexPath
  }
  
  func numberOfRows(in section: Int) -> Int {
    if section == sectionHeaders.index(of: "Language") {
      return interactor.languageValues.count
    } else if section == sectionHeaders.index(of: "UserID") {
      return interactor.userIDValues.count
    } else {
      return interactor.sortTypeValues.count
    }
  }
  
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath) {
    let currentSetting = interactor.currentSetting
    let title: String
    
    if indexPath.section == sectionHeaders.index(of: "Language") {
      title = interactor.languageValues[indexPath.row]
    } else if indexPath.section == sectionHeaders.index(of: "UserID") {
      title = interactor.userIDValues[indexPath.row]
    } else {
      title = interactor.sortTypeValues[indexPath.row]
    }
    cell.setTitleText(title.capitalized)
    
    if title == "\(currentSetting.language)" || title == "\(currentSetting.userID)" || title == "\(currentSetting.sortType)" {
      view.determineTalbeViewRowSelection(willSelect: true, indexPath: indexPath, animated: true)
    }
  }
}


// MARK: - SettingInteractorOutputProtocol

extension SettingPresenter: SettingInteractorOutputProtocol {
  
}
