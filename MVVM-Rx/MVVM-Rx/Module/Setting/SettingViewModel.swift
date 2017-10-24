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
  var willSelectTableViewRow: PublishSubject<(IndexPath, [IndexPath]?)> { get }
  var didSelectTableViewRow: PublishSubject<IndexPath> { get }
  var checkInitialRowSelection: PublishSubject<(String, IndexPath)> { get }
  
  // UI
  var popViewController: Driver<Bool> { get }
  var rowSelection: Driver<(Bool, IndexPath, Bool)> { get }
  var sectionedItems: Driver<[SettingSection]> { get }
  var willSelectTableViewRowIndexPath: Variable<IndexPath?> { get }
}

// MARK: - Class Implementation

struct SettingViewModel: SettingViewModelType {
  
  typealias Language = ServiceSetting.Language
  typealias UserID   = ServiceSetting.UserID
  typealias SortType = ServiceSetting.SortType
  
  // MARK: Properties
  
  let disposeBag = DisposeBag()
  
  // MARK: -> Event
  
  let didTapSaveBarButton = PublishSubject<Void>()
  let willSelectTableViewRow = PublishSubject<(IndexPath, [IndexPath]?)>()
  let didSelectTableViewRow = PublishSubject<IndexPath>()
  let checkInitialRowSelection = PublishSubject<(String, IndexPath)>()
  
  // MARK: <- UI
  
  let popViewController: Driver<Bool>
  let rowSelection: Driver<(Bool, IndexPath, Bool)>
  let sectionedItems: Driver<[SettingSection]>
  let willSelectTableViewRowIndexPath: Variable<IndexPath?>
  
  // MARK: - Initialize
  
  init(initialData: ServiceSetting = ServiceSetting(), completion: ((ServiceSetting) -> ())? = nil) {
    var currentSetting = initialData
    
    let settingSections = [
      SettingSection(model: "\(Language.self)", items: Language.allValues.map { "\($0)" }),
      SettingSection(model: "\(UserID.self)", items: UserID.allValues.map { "\($0)" }),
      SettingSection(model: "\(SortType.self)", items: SortType.allValues.map { "\($0)" })
    ]
    sectionedItems = Driver.just(settingSections)
    
    
    // TableView Selection
    
    let selectRowEvent = PublishSubject<(Bool, IndexPath, Bool)>()
    rowSelection = selectRowEvent
      .asDriver(onErrorJustReturn: (false, IndexPath(), false))
    
    checkInitialRowSelection.asObserver()
      .subscribe(onNext: { (item, indexPath) in
        let settings = ["\(initialData.language)", "\(initialData.userID)", "\(initialData.sortType)"]
        if settings.contains(item) {
          selectRowEvent.onNext((true, indexPath, true))
        }
      }).disposed(by: disposeBag)
    
    let _willSelectTableViewRowIndexPath = Variable<IndexPath?>(nil)
    willSelectTableViewRowIndexPath = _willSelectTableViewRowIndexPath
    
    willSelectTableViewRow.asObserver()
      .subscribe(onNext: { indexPath, selectedRows in
        for selectedIndexPath in selectedRows! {
          if selectedIndexPath.section == indexPath.section {
            selectRowEvent.onNext((false, selectedIndexPath, false))
          }
        }
        _willSelectTableViewRowIndexPath.value = indexPath
      }).disposed(by: disposeBag)

    didSelectTableViewRow.asObserver()
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
    
    
    // Save & Pop
    
    popViewController = didTapSaveBarButton
      .do(onNext: { _ in completion?(currentSetting) })
      .map { _ in true }
      .asDriver(onErrorJustReturn: true)
  }
}
