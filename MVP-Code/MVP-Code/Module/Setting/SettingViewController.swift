//
//  SettingViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol SettingViewType: ViewType {
  func exit(animated: Bool)
  func determineTalbeViewRowSelection(willSelect: Bool, indexPath: IndexPath, animated: Bool)
}

// MARK: - Class Implentation

final class SettingViewController: BaseViewController {

  // MARK: Properties
  
  private let presenter: SettingPresenterType
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .grouped)
  
  // MARK: UI Metrics
  
  private struct UI {
    static let tableViewFrame = UIScreen.main.bounds
    static let tableViewSectionHeaderHeight = CGFloat(40)
    static let tableViewRowHeight = CGFloat(40)
    static let tableViewFooterHeight = CGFloat(0)
  }
  
  // MARK: Initialize
  
  init(presenter: SettingPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    presenter.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func setupUI() {
    navigationItem.title = "Setting"
    
    tableView.separatorColor = tableView.backgroundColor
    tableView.rowHeight = UI.tableViewRowHeight
    tableView.sectionFooterHeight = UI.tableViewFooterHeight
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


// MARK: - SettingViewType

extension SettingViewController: SettingViewType {
  func exit(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }
  
  func determineTalbeViewRowSelection(willSelect: Bool, indexPath: IndexPath, animated: Bool) {
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UI.tableViewSectionHeaderHeight
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

