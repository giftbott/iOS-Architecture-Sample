//
//  SettingViewModel.swift
//  sss
//
//  Created by giftbot on 2017. 10. 17..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

typealias SettingSection = SectionModel<String, String>

protocol SettingViewModelType: ViewModelType {
  // Event
  var didTapSaveBarButton: PublishSubject<Void> { get }
  var willSelectTableViewRow: PublishSubject<(_: IndexPath, selectedIndexPaths: [IndexPath]?)> { get }
  var didSelectTableViewRow: PublishSubject<IndexPath> { get }
  var configureCell: PublishSubject<IndexPath> { get }
  
  // UI
  var popViewController: Driver<Bool> { get }
  var rowSelection: Driver<(selected: Bool, indexPath: IndexPath, animated: Bool)> { get }
  var sectionedItems: Driver<[SettingSection]> { get }
  var willSelectTableViewRowIndexPath: BehaviorRelay<IndexPath?> { get }
}

// MARK: - Class Implementation

struct SettingViewModel: SettingViewModelType {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  let disposeBag = DisposeBag()
  
  // MARK: -> Event
  
  let didTapSaveBarButton = PublishSubject<Void>()
  let willSelectTableViewRow = PublishSubject<(_: IndexPath, selectedIndexPaths: [IndexPath]?)>()
  let didSelectTableViewRow = PublishSubject<IndexPath>()
  let configureCell = PublishSubject<IndexPath>()
  
  // MARK: <- UI
  
  let popViewController: Driver<Bool>
  let rowSelection: Driver<(selected: Bool, indexPath: IndexPath, animated: Bool)>
  let sectionedItems: Driver<[SettingSection]>
  let willSelectTableViewRowIndexPath: BehaviorRelay<IndexPath?>
  
  // MARK: - Initialize
  
  init(initialData: ServiceSetting = ServiceSetting(), completion: ((ServiceSetting) -> ())? = nil) {
    var currentSetting = initialData
    
    // TableView Data
    
    let settingSections = [
      SettingSection(model: "\(Language.self)", items: Language.allValues.map { "\($0)" }),
      SettingSection(model: "\(UserID.self)", items: UserID.allValues.map { "\($0)" }),
      SettingSection(model: "\(SortType.self)", items: SortType.allValues.map { "\($0)" })
    ]
    sectionedItems = Driver.just(settingSections)
    
    // TableView Selection
    
    let selectRowEvent = PublishSubject<(selected: Bool, indexPath: IndexPath, animated: Bool)>()
    rowSelection = selectRowEvent
      .asDriver(onErrorJustReturn: (selected: false, indexPath: IndexPath(), animated: false))

    let _willSelectTableViewRowIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    willSelectTableViewRowIndexPath = _willSelectTableViewRowIndexPath
    
    willSelectTableViewRow
      .subscribe(onNext: { indexPath, selectedIndexPaths in
        guard let selectedIndexPaths = selectedIndexPaths else { return }
        for selectedIndexPath in selectedIndexPaths {
          if selectedIndexPath.section == indexPath.section {
            selectRowEvent.onNext((selected: false, indexPath: selectedIndexPath, animated: false))
          }
        }
        _willSelectTableViewRowIndexPath.accept(indexPath)
      }).disposed(by: disposeBag)

    didSelectTableViewRow
      .subscribe(onNext: { indexPath in
        let sectionHeader = settingSections[indexPath.section].model
        if sectionHeader == "\(Language.self)" {
          currentSetting.language = Language.allValues[indexPath.row]
        } else if sectionHeader == "\(UserID.self)" {
          currentSetting.userID = UserID.allValues[indexPath.row]
        } else {
          currentSetting.sortType = SortType.allValues[indexPath.row]
        }
      }).disposed(by: disposeBag)
    
    let settings = ["\(initialData.language)", "\(initialData.userID)", "\(initialData.sortType)"]
    configureCell
      .subscribe(onNext: { indexPath in
        let item = settingSections[indexPath.section].items[indexPath.row]
        if settings.contains(item) {
          selectRowEvent.onNext((selected: true, indexPath: indexPath, animated: true))
        }
      }).disposed(by: disposeBag)
    
    // Save & Pop
    
    popViewController = didTapSaveBarButton
      .do(onNext: { _ in completion?(currentSetting) })
      .map { _ in true }
      .asDriver(onErrorJustReturn: true)   
  }
}
