//
//  AppDelegate.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
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
    let repositoriesPresenter = RepositoriesPresenter(serviceSetting: ServiceSetting.decode())
    let repositoriesViewController = RepositoriesViewController(presenter: repositoriesPresenter)
    window?.rootViewController = UINavigationController(rootViewController: repositoriesViewController)
    window?.makeKeyAndVisible()
  }
}
