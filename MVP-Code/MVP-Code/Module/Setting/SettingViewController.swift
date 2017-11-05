//
//  SettingViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 2..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol SettingViewType: ViewType {
  func pop(animated: Bool)
  func selectTableViewRow(at indexPath: IndexPath, animated: Bool)
  func deselectTableViewRow(at indexPath: IndexPath, animated: Bool)
}

// MARK: - Class Implentation

final class SettingViewController: BaseViewController {

  // MARK: UI Metrics
  
  private struct UI {
    static let tableViewFrame = UIScreen.main.bounds
    static let tableViewRowHeight = CGFloat(40)
    static let tableViewHeaderHeight = CGFloat(40)
    static let tableViewFooterHeight = CGFloat(0)
  }
  
  // MARK: Properties
  
  private let presenter: SettingPresenterType
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .grouped)
  
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
  
  override func setupUI() {
    navigationItem.title = "Setting"
    
    tableView.rowHeight = UI.tableViewRowHeight
    tableView.sectionHeaderHeight = UI.tableViewHeaderHeight
    tableView.sectionFooterHeight = UI.tableViewFooterHeight
    tableView.separatorColor = tableView.backgroundColor
    tableView.allowsMultipleSelection = true
    tableView.register(cell: SettingTableViewCell.self)
    view.addSubview(tableView)
  }
  
  override func setupBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .save, target: self, action: #selector(didTapSaveBarButton)
    )
  }
  
  // MARK: Target Action
  
  @objc func didTapSaveBarButton() {
    presenter.saveCurrentSetting()
  }
}


// MARK: - SettingViewType

extension SettingViewController: SettingViewType {
  func pop(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }
  
  func selectTableViewRow(at indexPath: IndexPath, animated: Bool) {
    tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
  }
  
  func deselectTableViewRow(at indexPath: IndexPath, animated: Bool) {
    tableView.deselectRow(at: indexPath, animated: animated)
  }
}


// MARK: - TableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return presenter.willSelectTableViewRow(at: indexPath, selectedRows: tableView.indexPathsForSelectedRows)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectTableViewRow(at: indexPath)
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
    let cell = tableView.dequeue(SettingTableViewCell.self)!
    presenter.configureCell(cell, forRowAt: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return presenter.sectionHeaders[section]
  }
}

