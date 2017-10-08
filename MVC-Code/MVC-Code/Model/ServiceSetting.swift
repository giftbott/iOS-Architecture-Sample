//
//  ServiceSetting.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 7..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

typealias Language = ServiceSetting.Language
typealias UserID   = ServiceSetting.UserID
typealias SortType = ServiceSetting.SortType

struct ServiceSetting {
  var language = Language.swift
  var userID   = UserID.all
  var sortType = SortType.stars
  
  enum Language {
    case swift, objc, java, kotlin, python
    static let allValues: [Language] = [.swift, .objc, .java, .kotlin, .python]
  }
  enum UserID {
    case all, giftbott
    static let allValues: [UserID] = [.all, .giftbott]
  }
  enum SortType {
    case stars, forks, updated
    static let allValues: [SortType] = [.stars, .forks, .updated]
  }
}
