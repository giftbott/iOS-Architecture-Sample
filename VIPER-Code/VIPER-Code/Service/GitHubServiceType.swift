//
//  GitHubServiceType.swift
//  VIPER-Code
//
//  Created by giftbot on 2017. 10. 15..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

protocol GitHubServiceType {
  func fetchGitHubRepositories(
    by setting: ServiceSetting,
    completion: @escaping (Result<[Repository]>) -> ()
  )
}
