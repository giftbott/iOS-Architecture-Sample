//
//  BaseViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 4..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

// MARK: - BaseView Protocol

protocol BaseViewType: class {
}

// MARK: - BaseView Controller

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

