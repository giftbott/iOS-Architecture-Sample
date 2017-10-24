//
//  AppDelegate.swift
//  MVVM-Rx
//
//  Created by giftbot on 2017. 10. 24..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupKeyWindow()
    return true
  }
  
  private func setupKeyWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    let repositoriesViewModel = RepositoriesViewModel(serviceSetting: ServiceSetting.decode())
    let repositoriesView = RepositoriesViewController.create(with: repositoriesViewModel)
    let navigationController = UINavigationController(rootViewController: repositoriesView)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}

