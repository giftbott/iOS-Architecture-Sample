//
//  ServiceSetting.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 7..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

struct ServiceSetting: Codable {
  var language = Language.swift
  var userID   = UserID.all
  var sortType = SortType.stars
  
  enum Language: String, Codable {
    case swift, objc, java, kotlin, python
    static let allValues: [Language] = [.swift, .objc, .java, .kotlin, .python]
  }
  enum UserID: String, Codable {
    case all, giftbott
    static let allValues: [UserID] = [.all, .giftbott]
  }
  enum SortType: String, Codable {
    case stars, forks, updated
    static let allValues: [SortType] = [.stars, .forks, .updated]
  }
  
  // MARK: Encode & Decode Helper
  
  func encoded() {
    do {
      let settingData = try JSONEncoder().encode(self)
      try settingData.write(to: ServiceSetting.encodingPath())
    } catch let error {
      print("Encoding data has failed with error: ", error.localizedDescription)
    }
  }
  
  static func decode() -> ServiceSetting {
    do {
      let decodingData = try Data(contentsOf: ServiceSetting.encodingPath())
      let serviceSetting = try JSONDecoder().decode(ServiceSetting.self, from: decodingData)
      return serviceSetting
    } catch let error {
      print("Decoding data has failed with error: ", error.localizedDescription)
      return ServiceSetting()
    }
  }
  
  private static func encodingPath() -> URL {
    let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let path = document.appending("/currentSetting.data")
    return URL(fileURLWithPath: path)
  }
}

// MARK: - Equatable

extension ServiceSetting: Equatable {
  static func ==(lhs: ServiceSetting, rhs: ServiceSetting) -> Bool {
    return lhs.language == rhs.language && lhs.userID == rhs.userID && lhs.sortType == rhs.sortType
  }
}

