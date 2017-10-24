//
//  Reactive+Base.swift
//  sss
//
//  Created by giftbot on 2017. 10. 23..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
  var viewWillAppear: ControlEvent<Void> {
    let viewWillAppear = methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
    return ControlEvent(events: viewWillAppear)
  }
}

extension Reactive where Base: URLSession {
  func dataTask(request: URLRequest) -> Single<Data> {
    return Single.create(subscribe: { observer -> Disposable in
      let task = self.base.dataTask(with: request) { (data, response, error) in
        guard let response = response, let data = data else {
          observer(.error(error ?? ServiceError.unknown))
          return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
          observer(.error(ServiceError.invalidResponse(response)))
          return
        }
        guard 200..<400 ~= httpResponse.statusCode else {
          observer(.error(ServiceError.requestFailed(response: httpResponse, data: data)))
          return
        }
        observer(.success(data))
      }
      task.resume()
      return Disposables.create(with: task.cancel)
    })
  }
}

extension Reactive where Base: UITableView {
  var willDisplayHeaderViewForSection: ControlEvent<(UIView, Int)> {
    let selector = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
    let source = self.delegate.methodInvoked(selector)
      .map { arg -> (UIView, Int) in
        let headerView = try castOrThrow(UIView.self, arg[1])
        let section = try castOrThrow(Int.self, arg[2])
        return (headerView, section)
      }
    return ControlEvent(events: source)
  }
}

extension RxTableViewDelegateProxy {
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    self._forwardToDelegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
  }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  return returnValue
}

