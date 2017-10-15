//
//  Router.swift
//  NewViperTest
//
//  Created by giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

enum Router {
  enum Repositories {
    case editSetting(_: ServiceSetting, completion: (ServiceSetting)->())
    case repository(url: URL)
    case alert(title: String, message: String)
  }
}
