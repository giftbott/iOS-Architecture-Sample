//
//  UIViewExtensions.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 1..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    for view in views {
      addSubview(view)
    }
  }
}
