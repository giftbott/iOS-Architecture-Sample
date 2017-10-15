//
//  BaseViewController.swift
//  VIPER-Code
//
//  Created by giftbot on 2017. 10. 10..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  // MARK: Initialize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  func setupUI() {
    // Override
  }
  
  func setupBinding() {
    // Override
  }
  
  // MARK: Memory Warning & Deinit
  
  override func didReceiveMemoryWarning() {
    // print("\(self) did Receive Memory Warning")
  }
  
  deinit {
    // print("\(self) has deinitialized")
  }
}
