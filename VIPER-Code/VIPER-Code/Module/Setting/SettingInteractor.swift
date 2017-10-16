//
//  SettingInteractor.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol SettingInteractorInputProtocol: class {
  // Presenter -> Interactor
  var currentSetting: ServiceSetting { get }
  var settingHeaders: [String] { get }
  var languageValues: [String] { get }
  var userIDValues: [String] { get }
  var sortTypeValues: [String] { get }
  
  func setServiceSettingForValue(at indexPath: IndexPath)
}

// MARK: - Class Implementation

final class SettingInteractor {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  // MARK: Properties
  
  weak var presenter: SettingInteractorOutputProtocol!
  var currentSetting: ServiceSetting
  
  let settingHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  let languageValues = Language.allValues.map { "\($0)" }
  let userIDValues   = UserID.allValues.map { "\($0)" }
  let sortTypeValues = SortType.allValues.map { "\($0)" }
  
  // MARK: Initialize
  
  init(serviceSetting: ServiceSetting) {
    currentSetting = serviceSetting
  }
}

// MARK: - SettingInteractorInputProtocol

extension SettingInteractor: SettingInteractorInputProtocol {
  func setServiceSettingForValue(at indexPath: IndexPath) {
    if indexPath.section == settingHeaders.index(of: "\(Language.self)") {
      currentSetting.language = Language.allValues[indexPath.row]
    } else if indexPath.section == settingHeaders.index(of: "\(UserID.self)") {
      currentSetting.userID = UserID.allValues[indexPath.row]
    } else {
      currentSetting.sortType = SortType.allValues[indexPath.row]
    }
  }
}
