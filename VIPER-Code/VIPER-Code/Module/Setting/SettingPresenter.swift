//
//  SettingPresenter.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

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
  
  // TableView
  
  func didSelectTableViewRow(at indexPath: IndexPath) {
    interactor.setServiceSettingForValue(at: indexPath)
  }
  
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath? {
    guard let selectedIndexPaths = selectedRows else { return nil }
    for selectedIndexPath in selectedIndexPaths {
      if selectedIndexPath.section == indexPath.section {
        view.determineTableViewRowSelection(willSelect: false, indexPath: selectedIndexPath, animated: false)
      }
    }
    return indexPath
  }
  
  func numberOfRows(in section: Int) -> Int {
    return interactor.settingValues[section].count
  }
  
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath) {
    let currentSetting = interactor.currentSetting
    let title = interactor.settingValues[indexPath.section][indexPath.row]
    cell.setTitleText(title.capitalized)
    
    let settings = ["\(currentSetting.language)", "\(currentSetting.userID)", "\(currentSetting.sortType)"]
    if settings.contains(title) {
      view.determineTableViewRowSelection(willSelect: true, indexPath: indexPath, animated: true)
    }
  }
}


// MARK: - SettingInteractorOutputProtocol

extension SettingPresenter: SettingInteractorOutputProtocol {
  
}
