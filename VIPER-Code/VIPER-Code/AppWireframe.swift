//
//  AppWireframe.swift
//  VIPER-Code
//
//  Created by giftbot on 2017. 10. 16..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

class AppWireframe: BaseWireframe {
  static let shared = AppWireframe()
  private override init() { }
  
  weak var window: UIWindow!
  
  func setupKeyWindow(_ window: UIWindow, viewController: UIViewController) {
    self.window = window
    let navigationController = UINavigationController(rootViewController: viewController)
    show(navigationController, with: .root(window: window))
    window.makeKeyAndVisible()
  }
}
