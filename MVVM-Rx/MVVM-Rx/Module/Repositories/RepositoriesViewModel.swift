//
//  RepositoriesViewModel.swift
//  sss
//
//  Created by giftbot on 2017. 10. 17..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

typealias RepositoriesData = SectionModel<String, Repository>

protocol RepositoriesViewModelType: ViewModelType {
  // Event
  var viewWillAppear: PublishSubject<Void> { get }
  var didTapLeftBarButton: PublishSubject<Void> { get }
  var didTapRightBarButton: PublishSubject<Void> { get }
  var didPulltoRefresh: PublishSubject<Void> { get }
  var didCellSelected: PublishSubject<Repository> { get }
  
  // UI
  var isNetworking: Driver<Bool> { get }
  var showAlert: Driver<(String, String)> { get }
  var repositories: Driver<[RepositoriesData]> { get }
  var editSetting: Driver<SettingViewModelType> { get }
  var showRepository: Driver<String> { get }
}

// MARK: - Class Implementation

struct RepositoriesViewModel: RepositoriesViewModelType {
  
  // MARK: Properties
  // MARK: -> Event
  
  let viewWillAppear = PublishSubject<Void>()
  let didTapLeftBarButton = PublishSubject<Void>()
  let didTapRightBarButton = PublishSubject<Void>()
  let didPulltoRefresh = PublishSubject<Void>()
  let didCellSelected = PublishSubject<Repository>()
  
  // MARK: <- UI
  
  let isNetworking: Driver<Bool>
  let showAlert: Driver<(String, String)>
  let repositories: Driver<[RepositoriesData]>
  let editSetting: Driver<SettingViewModelType>
  let showRepository: Driver<String>
  
  // MARK: - Initialize
  
  init(gitHubService: GitHubServiceType = GitHubService(), serviceSetting: ServiceSetting) {
    var currentSetting = serviceSetting
    
    let onNetworking = PublishSubject<Bool>()
    isNetworking = onNetworking.asDriver(onErrorJustReturn: false)
    
    let onError = PublishSubject<Error>()
    showAlert = onError
      .map { error -> (String, String) in
        return ("Error", error.localizedDescription)
      }.asDriver(onErrorJustReturn: ("Error", "Unknown Error"))
    
    // API Data
    
    repositories = Observable<Void>
      .merge([viewWillAppear,  didTapLeftBarButton, didPulltoRefresh])
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .do(onNext: { _ in onNetworking.onNext(true) })
      .flatMapLatest {
        return gitHubService.fetchGitHubRepositories(by: currentSetting)
          .retry(2)
          .do { onNetworking.onNext(false) }
          .catchError({ error -> Single<[Repository]> in
            onError.onNext(error)
            return .never()
          })
      }
      .map { [RepositoriesData(model: "", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  
    // Navigation
    
    editSetting = didTapRightBarButton
      .map {
        return SettingViewModel(initialData: currentSetting) { setting in
          if currentSetting != setting {
            currentSetting = setting
            currentSetting.encoded()
          }
        }
      }.asDriver(onErrorJustReturn: SettingViewModel())
    
    showRepository = didCellSelected
      .map { $0.url }
      .asDriver(onErrorJustReturn: "")
  }
}
