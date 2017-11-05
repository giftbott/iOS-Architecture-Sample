//
//  SettingPresenter.swift
//  MVP-Code
//
//  Created by giftbot on 2017. 10. 9..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol SettingPresenterType: class, PresenterType {
  weak var view: SettingViewType! { get set }
  var sectionHeaders: [String] { get }
  
  func saveCurrentSetting()
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath?
  func didSelectTableViewRow(at indexPath: IndexPath)
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath)
}

// MARK: - Class Implementation

final class SettingPresenter {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  // MARK: Properties
  
  weak var view: SettingViewType!
  let sectionHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  
  private let sectionValues = [
    Language.allValues.map { "\($0)" },
    UserID.allValues.map { "\($0)" },
    SortType.allValues.map { "\($0)" }
  ]
  private var currentSetting: ServiceSetting
  private var saveActionHandler: (ServiceSetting) -> ()
  
  // MARK: Initialize
  
  init(initialData: ServiceSetting, completion: @escaping (ServiceSetting) -> ()) {
    currentSetting = initialData
    saveActionHandler = completion
  }
}


// MARK: - SettingPresenterType

extension SettingPresenter: SettingPresenterType {
  func saveCurrentSetting() {
    saveActionHandler(currentSetting)
    view.pop(animated: true)
  }
  
  // MARK: TableView Handler
  
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath? {
    guard let selectedIndexPaths = selectedRows else { return nil }
    selectedIndexPaths
      .filter { $0.section == indexPath.section }
      .forEach { view.deselectTableViewRow(at: $0, animated: false) }
    return indexPath
  }
  
  func didSelectTableViewRow(at indexPath: IndexPath) {
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      currentSetting.language = Language.allValues[indexPath.row]
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      currentSetting.userID = UserID.allValues[indexPath.row]
    } else {
      currentSetting.sortType = SortType.allValues[indexPath.row]
    }
  }
  
  func numberOfRows(in section: Int) -> Int {
    return sectionValues[section].count
  }
  
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath) {
    let title = sectionValues[indexPath.section][indexPath.row]
    cell.setTitleText(title.capitalized)
    
    let settings = ["\(currentSetting.language)", "\(currentSetting.userID)", "\(currentSetting.sortType)"]
    if settings.contains(title) {
      view.selectTableViewRow(at: indexPath, animated: true)
    }
  }
}
