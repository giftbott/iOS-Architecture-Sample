//
//  ServiceResult.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 3..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

enum Result<T> {
  case success(T)
  case error(Error)
}

enum ServiceError: Error {
  case urlTransformFailed
  case parseFailed
}
