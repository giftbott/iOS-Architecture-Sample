//
//  SettingViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController, ViewBindable {
  
  // MARK: Properties
  
  lazy var v = SettingView(controlBy: self)
  
  private let sectionHeaders = ["\(Language.self)", "\(UserID.self)", "\(SortType.self)"]
  private let languages = Language.allValues.map { "\($0)".capitalized }
  private let userIDs   = UserID.allValues.map { "\($0)".capitalized }
  private let sortTypes = SortType.allValues.map { "\($0)".capitalized }
  
  private var currentSetting: ServiceSetting
  private var saveActionHandler: (ServiceSetting) -> ()
  
  // MARK: Initialize
  
  init(initialData: ServiceSetting, completion: @escaping (ServiceSetting) -> ()) {
    currentSetting = initialData
    saveActionHandler = completion
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View LifeCycle
  
  override func loadView() {
    view = v
  }
  
  // MARK: Action Handler
  
  @objc func saveCurrentSetting() {
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
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
    let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as! SettingTableViewCell
    
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
