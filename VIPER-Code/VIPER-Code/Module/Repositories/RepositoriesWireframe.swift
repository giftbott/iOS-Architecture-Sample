//
//  RepositoriesWireframe.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit
import SafariServices

protocol RepositoriesWireframeProtocol: class {
  // Presenter -> Wireframe
  func navigate(to route: Router.Repositories)
}

final class RepositoriesWireframe: BaseWireframe {
  
  static func createModule(service: GitHubServiceType = GitHubService(), serviceSetting: ServiceSetting) -> RepositoriesViewController {
    let view = RepositoriesViewController()
    let wireframe = RepositoriesWireframe()
    let interactor = RepositoriesInteractor(service: service, serviceSetting: serviceSetting)
    let presenter = RepositoriesPresenter(view: view, wireframe: wireframe, interactor: interactor)
    
    view.presenter = presenter
    wireframe.view = view
    interactor.presenter = presenter
    
    return view
  }
  
  private func showRepository(by url: URL) {
    let safariViewController = SFSafariViewController(url: url)
    show(safariViewController, with: .push)
  }
  
  private func showSettingView(with data: ServiceSetting, completion: @escaping (ServiceSetting) -> ()) {
    let settingView = SettingWireframe.createModule(serviceSetting: data, completion: completion)
    show(settingView, with: .push)
  }
  
  private func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    show(alertController, with: .present(from: view), animated: true)
  }
}

// MARK: - WireframeProtocol

extension RepositoriesWireframe: RepositoriesWireframeProtocol {
  func navigate(to route: Router.Repositories) {
    switch route {
    case .repository(let url):
      showRepository(by: url)
    case .editSetting(let currentSetting, let completion):
      showSettingView(with: currentSetting, completion: completion)
    case .alert(let title, let message):
      presentAlert(title: title, message: message)
    }
  }
}
