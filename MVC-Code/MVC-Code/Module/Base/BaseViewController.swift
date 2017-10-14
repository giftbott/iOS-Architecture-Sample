//
//  BaseViewController.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 4..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol ViewControllerType: class {
}

class BaseViewController: UIViewController, ViewControllerType {
  
  // MARK: Initialize
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Deinit
  
  deinit {
    // print("\(self) has deinitialized")
  }
}
