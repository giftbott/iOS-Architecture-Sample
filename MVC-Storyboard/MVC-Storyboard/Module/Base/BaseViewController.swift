//
//  BaseViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 4..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    // Override
  }
  
  override func didReceiveMemoryWarning() {
    // print("\(self) did Receive Memory Warning")
  }
  
  deinit {
    // print("\(self) has deinitialized")
  }
}

