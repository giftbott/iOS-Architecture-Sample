//
//  GitHubService.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

typealias ServiceSetting = GitHubService.ServiceSetting
typealias Language = GitHubService.ServiceSetting.Language
typealias UserID   = GitHubService.ServiceSetting.UserID
typealias SortType = GitHubService.ServiceSetting.SortType

struct GitHubService {
  
  // MARK: Properties
  
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
  
  private var session: URLSession { return URLSession.shared }
  
  // MARK: DataTask
  
  func fetchGitHubRepositories(
    by setting: ServiceSetting,
    completion: @escaping (Result<[[String: Any]]>) -> ()
  ) {
    let baseUrl  = "https://api.github.com/search/repositories?q="
    let language = "language:\(setting.language)"
    let userID   = setting.userID == .all ? "" : "+user:\(setting.userID)"
    let sortType = "&sort=\(setting.sortType)"
    
    guard let url = URL(string: baseUrl + language + userID + sortType) else { return }
    
    let dataTask = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.error(error))
        return
      }
      
      guard let data = data,
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let json = jsonObject as? [String: Any],
        let items = json["items"] as? [[String: Any]]
      else {
        completion(.error(ServiceError.parseFailed))
        return
      }
      
      completion(.success(items))
    }
    
    dataTask.resume()
  }
}
