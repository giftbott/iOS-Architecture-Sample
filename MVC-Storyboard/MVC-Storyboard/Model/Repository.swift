//
//  Repository.swift
//  MVC-Storyboard
//
//  Created by giftbot on 2017. 10. 1..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

struct Repository {
  let fullName: String
  let description: String
  let starCount: Int
  let forkCount: Int
  let url: String
}

extension Repository {
  init?(json: [String: Any]) {
    guard
      let fullName = json["full_name"] as? String,
      let description = json["description"] as? String,
      let starCount = json["stargazers_count"] as? Int,
      let forkCount = json["forks_count"] as? Int,
      let url = json["html_url"] as? String
      else { return nil }
    
    self.init(
      fullName: fullName,
      description: description,
      starCount: starCount,
      forkCount: forkCount,
      url: url
    )
  }
}
