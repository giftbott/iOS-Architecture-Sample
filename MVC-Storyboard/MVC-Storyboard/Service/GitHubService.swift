//
//  GitHubService.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

struct GitHubService {
  
  // MARK: Properties
  
  private var session: URLSession { return URLSession.shared }
  
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
      if let error = error, data == nil {
        completion(.error(error))
        return
      }
      
      do {
        let repositories = try JSONDecoder().decode(Repositories.self, from: data!)
        completion(.success(repositories.items))
      } catch let error {
        completion(.error(error))
      }
    }
    
    dataTask.resume()
  }
}
