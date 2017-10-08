//
//  BaseView.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 3..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

class BaseView<ViewController: BaseViewController>: UIView {
  // MARK: Properties
  
  weak var vc: ViewController!
  
  // MARK: Initialize
  
  required init(controlBy viewController: ViewController) {
    vc = viewController
    super.init(frame: UIScreen.main.bounds)
    setupUI()
    setupBinding()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    // Override
  }
  
  func setupBinding() {
    // Override
  }
  
  // MARK: Deinit
  
  deinit {
    // print("\(self) has deinitialized")
  }
}

