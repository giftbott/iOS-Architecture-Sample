//
//  SettingViewController.swift
//  sss
//
//  Created by giftbot on 2017. 10. 17..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

final class SettingViewController: UIViewController, ViewType {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let tableViewFrame = UIScreen.main.bounds
    static let tableViewSectionHeaderHeight = CGFloat(40)
    static let tableViewRowHeight = CGFloat(40)
    static let tableViewFooterHeight = CGFloat(0)
  }
  
  // MARK: Properties
  
  var disposeBag: DisposeBag!
  var viewModel: SettingViewModelType!
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .grouped)
  private let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
  
  // MARK: Setup UI
  
  func setupUI() {
    navigationItem.title = "Setting"
    navigationItem.rightBarButtonItem = saveButton
    
    tableView.separatorColor = tableView.backgroundColor
    tableView.rowHeight = UI.tableViewRowHeight
    tableView.sectionHeaderHeight = UI.tableViewSectionHeaderHeight
    tableView.sectionFooterHeight = UI.tableViewFooterHeight
    tableView.allowsMultipleSelection = true
    tableView.register(cell: SettingTableViewCell.self)
    view.addSubview(tableView)
  }
  
  // MARK: - -> Rx Event Binding
  
  func setupEventBinding() {
    saveButton.rx.tap
      .bind(to: viewModel.didTapSaveBarButton)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .bind(to: viewModel.didSelectTableViewRow)
      .disposed(by: disposeBag)
    
    tableView.rx.willDisplayHeaderViewForSection
      .subscribe(onNext: { view, _ in
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .darkGray
      }).disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - <- Rx UI Binding
  
  func setupUIBinding() {
    let dataSource = RxTableViewSectionedReloadDataSource<SettingSection>(
      configureCell: { [weak self] (_, tableView, indexPath, item) in
        let cell = tableView.dequeue(SettingTableViewCell.self)!
        self?.viewModel.configureCell.onNext(indexPath)
        cell.setTitleText(item.capitalized)
        return cell
      }, titleForHeaderInSection: { (dataSource, index) -> String? in
        dataSource.sectionModels[index].model
    })
    
    viewModel.sectionedItems.asDriver()
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel.popViewController
      .drive(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: $0)
      }).disposed(by: disposeBag)
    
    viewModel.rowSelection
      .drive(onNext: { [weak self] (selected, indexPath, animated) in
        self?.tableViewRowSelection(willSelect: selected, indexPath: indexPath, animated: animated)
      }).disposed(by: disposeBag)
  }
  
  // MARK: Action Handler
  
  private func tableViewRowSelection(willSelect: Bool, indexPath: IndexPath, animated: Bool) {
    if willSelect {
      self.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    } else {
      self.tableView.deselectRow(at: indexPath, animated: animated)
    }
  }
}

// MARK: - TableViewDelegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    viewModel.willSelectTableViewRow
      .onNext((indexPath, selectedIndexPaths: tableView.indexPathsForSelectedRows))
    return viewModel.willSelectTableViewRowIndexPath.value
  }
  
  func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
