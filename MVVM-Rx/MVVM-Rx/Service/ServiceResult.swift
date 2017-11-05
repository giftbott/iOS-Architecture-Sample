//
//  ServiceResult.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 3..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

enum ServiceError: Error {
  case unknown
  case urlTransformFailed
  case requestFailed(response: HTTPURLResponse, data: Data?)
}
