//
//  RepositoriesViewController.swift
//  sss
//
//  Created by giftbot on 2017. 10. 17..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import SafariServices

import RxCocoa
import RxDataSources
import RxSwift

final class RepositoriesViewController: UIViewController, ViewType {
  
  // MARK: UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let tableViewFrame = UIScreen.main.bounds
    static let estimatedRowHeight = CGFloat(80)
  }
  
  // MARK: Properties
  
  var viewModel: RepositoriesViewModelType!
  var disposeBag: DisposeBag!
  private let tableView = UITableView(frame: UI.tableViewFrame, style: .plain)
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // MARK: Setup UI

  func setupUI() {
    navigationItem.title = "Repository List"
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh, target: nil, action: nil
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "btn_setting"), style: .plain, target: nil, action: nil
    )
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .mainColor
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = UI.estimatedRowHeight
    tableView.separatorColor = .mainColor
    tableView.separatorInset = UIEdgeInsetsMake(0, UI.baseMargin, 0, UI.baseMargin)
    tableView.register(cell: RepositoriesTableViewCell.self)
    
    indicatorView.color = .mainColor
    indicatorView.center = view.center
    
    view.addSubviews([tableView, indicatorView])
  }
  
  // MARK: - -> Rx Event Binding
  
  func setupEventBinding() {
    rx.viewWillAppear
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)

    navigationItem.leftBarButtonItem?.rx.tap
      .bind(to: viewModel.didTapLeftBarButton)
      .disposed(by: disposeBag)

    navigationItem.rightBarButtonItem?.rx.tap
      .bind(to: viewModel.didTapRightBarButton)
      .disposed(by: disposeBag)
    
    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .bind(to: viewModel.didPulltoRefresh)
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(RepositoriesData.Item.self)
      .bind(to: viewModel.didCellSelected)
      .disposed(by: disposeBag)
  }
  
  // MARK: - <- Rx UI Binding
  
  func setupUIBinding() {
    let dataSource = RxTableViewSectionedReloadDataSource<RepositoriesData>(
      configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeue(RepositoriesTableViewCell.self)!
        cell.configureWith(name: item.fullName,
                           description: item.description,
                           star: item.starCount,
                           fork: item.forkCount)
        return cell
    })
    
    viewModel.repositories
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    viewModel.isNetworking
      .drive(onNext: { [weak self] isNetworking in
        self?.showNetworkingAnimation(isNetworking)
      }).disposed(by: disposeBag)
    
    viewModel.showAlert
      .drive(onNext: { [weak self] (title, message) in
        self?.showAlert(title: title, message: message)
      }).disposed(by: disposeBag)
    
    // Navigation
    
    viewModel.editSetting
      .drive(onNext: { [weak self] viewModel in
        let view = SettingViewController.create(with: viewModel)
        self?.navigationController?.pushViewController(view, animated: true)
      }).disposed(by: disposeBag)
    
    viewModel.showRepository
      .drive(onNext: { [weak self] urlString in
        guard let url = URL(string: urlString) else { return }
        let safariViewController = SFSafariViewController(url: url)
        self?.navigationController?.pushViewController(safariViewController, animated: true)
      }).disposed(by: disposeBag)
  }
  
  // MARK: Action Handler
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(alertAction)
    present(alertController, animated: true)
  }
  
  private func showNetworkingAnimation(_ isNetworking: Bool) {
    if !isNetworking {
      indicatorView.stopAnimating()
      tableView.refreshControl?.endRefreshing()
    } else if !tableView.refreshControl!.isRefreshing {
      indicatorView.startAnimating()
    }
  }
}
