//
//  GitHubService.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

struct GitHubService: GitHubServiceType {
  
  // MARK: Properties
  
  private let session: URLSession
  
  // MARK: Initialize
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  // MARK: DataTask
  
  func fetchGitHubRepositories(
    by setting: ServiceSetting,
    completion: @escaping (Result<[Repository]>) -> ()
    ) {
    let baseUrl  = "https://api.github.com/search/repositories?q="
    let language = "language:\(setting.language)"
    let userID   = setting.userID == .all ? "" : "+user:\(setting.userID)"
    let sortType = "&sort=\(setting.sortType)"
    
    guard let url = URL(string: baseUrl + language + userID + sortType) else {
      completion(.error(ServiceError.urlTransformFailed))
      return
    }
    
    let dataTask = session.dataTask(with: url) { (data, response, error) in
      guard let response = response as? HTTPURLResponse, let data = data else {
        completion(.error(error ?? ServiceError.unknown))
        return
      }
      guard 200..<400 ~= response.statusCode else {
        completion(.error(ServiceError.requestFailed(response: response, data: data)))
        return
      }
      do {
        let repositories = try data.decode(Repositories.self)
        completion(.success(repositories.items))
      } catch let error {
        completion(.error(error))
      }
    }
    dataTask.resume()
  }
}

