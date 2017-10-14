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
  
  func didSelectTableViewRow(at indexPath: IndexPath)
  func willSelectTableViewRow(at indexPath: IndexPath, selectedRows: [IndexPath]?) -> IndexPath?
  func numberOfRows(in section: Int) -> Int
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath)
  func saveCurrentSetting()
}

// MARK: - Class Implementation

final class SettingPresenter {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  // MARK: Properties
  
  // protocol
  weak var view: SettingViewType!
  let sectionHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  
  // private
  private let languages = Language.allValues.map { "\($0)".capitalized }
  private let userIDs   = UserID.allValues.map { "\($0)".capitalized }
  private let sortTypes = SortType.allValues.map { "\($0)".capitalized }
  
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
    view.exit(animated: true)
  }
  
  // MARK: TableView Handler
  
  func didSelectTableViewRow(at indexPath: IndexPath) {
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      currentSetting.language = Language.allValues[indexPath.row]
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      currentSetting.userID = UserID.allValues[indexPath.row]
    } else {
      currentSetting.sortType = SortType.allValues[indexPath.row]
    }
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
    if section == sectionHeaders.index(of: "\(Language.self)") {
      return languages.count
    } else if section == sectionHeaders.index(of: "\(UserID.self)") {
      return userIDs.count
    } else {
      return sortTypes.count
    }
  }
  
  func configureCell(_ cell: SettingCellType, forRowAt indexPath: IndexPath) {
    let title: String
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      title = languages[indexPath.row]
      if title == "\(currentSetting.language)".capitalized {
        view.determineTalbeViewRowSelection(willSelect: true, indexPath: indexPath, animated: true)
      }
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      title = userIDs[indexPath.row]
      if title == "\(currentSetting.userID)".capitalized {
        view.determineTalbeViewRowSelection(willSelect: true, indexPath: indexPath, animated: true)
      }
    } else {
      title = sortTypes[indexPath.row]
      if title == "\(currentSetting.sortType)".capitalized {
        view.determineTalbeViewRowSelection(willSelect: true, indexPath: indexPath, animated: true)
      }
    }
    cell.setTitleText(title)
  }
}
