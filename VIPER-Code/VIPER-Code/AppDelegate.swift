//
//  AppDelegate.swift
//  VIPER-Code
//
//  Created by giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupAppWireframe()
    return true
  }
  
  private func setupAppWireframe() {
    window = UIWindow(frame: UIScreen.main.bounds)
    let repositoriesView = RepositoriesWireframe.createModule(serviceSetting: ServiceSetting.decode())
    AppWireframe.shared.setupKeyWindow(window!, viewController: repositoriesView)
  }
}

