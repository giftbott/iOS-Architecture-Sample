//
//  SettingViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  // MARK: Properties
  
  private let sectionHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  private let sectionValues = [
    Language.allValues.map { "\($0)" },
    UserID.allValues.map { "\($0)" },
    SortType.allValues.map { "\($0)" }
  ]
  private var currentSetting: ServiceSetting!
  private var saveActionHandler: ((ServiceSetting) -> ())!
  
  // MARK: Initialize
  
  static func createWith(initialData: ServiceSetting, completion: @escaping (ServiceSetting) -> ()) -> SettingViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let `self` = storyboard.instantiateViewController(ofType: SettingViewController.self)
    self.currentSetting = initialData
    self.saveActionHandler = completion
    return self
  }

  // MARK: Action Handler
  
  @IBAction func saveCurrentSetting() {
    saveActionHandler(currentSetting)
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - TableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return nil }
    selectedIndexPaths
      .filter { $0.section == indexPath.section }
      .forEach { tableView.deselectRow(at: $0, animated: false) }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == sectionHeaders.index(of: "\(Language.self)") {
      currentSetting.language = Language.allValues[indexPath.row]
    } else if indexPath.section == sectionHeaders.index(of: "\(UserID.self)") {
      currentSetting.userID = UserID.allValues[indexPath.row]
    } else {
      currentSetting.sortType = SortType.allValues[indexPath.row]
    }
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
    return sectionValues[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(SettingTableViewCell.self, for: indexPath)
    let title = sectionValues[indexPath.section][indexPath.row]
    cell.setTitleText(title.capitalized)
    
    let settings = ["\(currentSetting.language)", "\(currentSetting.userID)", "\(currentSetting.sortType)"]
    if settings.contains(title) {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
}
