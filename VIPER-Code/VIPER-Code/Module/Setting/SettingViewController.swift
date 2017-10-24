//
//  SettingViewController.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol SettingViewProtocol: class {
  // Presenter -> View
  func determineTableViewRowSelection(willSelect: Bool, indexPath: IndexPath, animated: Bool)
}

// MARK: - Class Implementation

final class SettingViewController: BaseViewController {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let tableViewFrame = UIScreen.main.bounds
    static let tableViewRowHeight = CGFloat(40)
    static let tableViewHeaderHeight = CGFloat(40)
    static let tableViewFooterHeight = CGFloat(0)
  }
  
  // MARK: Properties
  
  var presenter: SettingPresenterProtocol!
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .grouped)
  
  // MARK: View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func setupUI() {
    navigationItem.title = "Setting"
    
    tableView.rowHeight = UI.tableViewRowHeight
    tableView.sectionHeaderHeight = UI.tableViewHeaderHeight
    tableView.sectionFooterHeight = UI.tableViewFooterHeight
    tableView.separatorColor = tableView.backgroundColor
    tableView.allowsMultipleSelection = true
    tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    view.addSubview(tableView)
  }
  
  override func setupBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    
    let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save,
                                        target: self,
                                        action: #selector(didTapSaveBarButton))
    navigationItem.rightBarButtonItem = saveBarButton
  }
  
  // MARK: Target Action
  
  @objc func didTapSaveBarButton() {
    presenter.saveCurrentSetting()
  }
}


// MARK: - SettingViewProtocol

extension SettingViewController: SettingViewProtocol {
  func determineTableViewRowSelection(willSelect: Bool, indexPath: IndexPath, animated: Bool) {
    if willSelect {
      tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    } else {
      tableView.deselectRow(at: indexPath, animated: animated)
    }
  }
}

// MARK: - TableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectTableViewRow(at: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return presenter.willSelectTableViewRow(at: indexPath, selectedRows: tableView.indexPathsForSelectedRows)
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
    return presenter.sectionHeaders.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as! SettingTableViewCell
    presenter.configureCell(cell, forRowAt: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return presenter.sectionHeaders[section]
  }
}

