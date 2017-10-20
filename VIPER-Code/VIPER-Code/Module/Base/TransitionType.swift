//
//  TransitionType.swift
//  NewViperTest
//
//  Created by giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

enum TransitionType {
  case root(window: UIWindow)
  case push
  case present(from: UIViewController)
}

