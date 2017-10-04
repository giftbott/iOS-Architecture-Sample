//
//  SettingViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController {
  
  // MARK: Properties
  
  fileprivate let sectionHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  fileprivate let languages = Language.allValues.map { "\($0)".capitalized }
  fileprivate let userIDs   = UserID.allValues.map { "\($0)".capitalized }
  fileprivate let sortTypes = SortType.allValues.map { "\($0)".capitalized }
  
  fileprivate var currentSetting: ServiceSetting!
  private var saveActionHandler: ((ServiceSetting) -> ())!
  
  // MARK: Initialize
  
  static func createWith(initialData: ServiceSetting, completion: @escaping (ServiceSetting) -> ()) -> SettingViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let settingViewController = storyboard.instantiateViewController(ofType: SettingViewController.self)
    settingViewController.currentSetting = initialData
    settingViewController.saveActionHandler = completion
    return settingViewController
  }
  
  // MARK: Action Handler
  
  @IBAction func saveCurrentSetting() {
    saveActionHandler(currentSetting)
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - TableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      currentSetting.language = Language.allValues[indexPath.row]
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      currentSetting.userID = UserID.allValues[indexPath.row]
    } else {
      currentSetting.sortType = SortType.allValues[indexPath.row]
    }
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return nil }
    for selected in selectedIndexPaths {
      if selected.section == indexPath.section {
        tableView.deselectRow(at: selected, animated: false)
      }
    }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let headerView = view as? UITableViewHeaderFooterView else { return }
    headerView.textLabel?.textColor = .darkGray
  }
}

// MARK: - TableViewDataSource

extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionHeaders.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == sectionHeaders.index(of: "\(Language.self)") {
      return languages.count
    } else if section == sectionHeaders.index(of: "\(UserID.self)") {
      return userIDs.count
    } else {
      return sortTypes.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
    
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      cell.setTitleText(languages[indexPath.row])
      if languages[indexPath.row] == "\(currentSetting.language)".capitalized {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      cell.setTitleText(userIDs[indexPath.row])
      if userIDs[indexPath.row] == "\(currentSetting.userID)".capitalized {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    } else {
      cell.setTitleText(sortTypes[indexPath.row])
      if sortTypes[indexPath.row] == "\(currentSetting.sortType)".capitalized {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
}
