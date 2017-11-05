//
//  SettingWireframe.swift
//  VIPER-Code
//
//  Created giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol SettingWireframeProtocol: class {
  // Presenter -> Wireframe
  func popViewController(animated: Bool)
}

// MARK: - Class Implementation

final class SettingWireframe: BaseWireframe, SettingWireframeProtocol {
  
  static func createModule(
    serviceSetting: ServiceSetting,
    completion: @escaping (ServiceSetting) -> ()
    ) -> SettingViewController {
    let view = SettingViewController()
    let wireframe = SettingWireframe()
    let interactor = SettingInteractor(serviceSetting: serviceSetting)
    let presenter = SettingPresenter(view: view, wireframe: wireframe, interactor: interactor, completion: completion)
    
    view.presenter = presenter
    wireframe.view = view
    interactor.presenter = presenter
    
    return view
  }
  
  func popViewController(animated: Bool) {
    pop(animated: true)
  }
}
