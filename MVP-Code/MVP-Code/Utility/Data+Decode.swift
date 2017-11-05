//
//  Data+Decode.swift
//  MVVM-Rx
//
//  Created by giftbot on 2017. 10. 25..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import Foundation

extension Data {
  func decode<T>(_ type: T.Type, decoder: JSONDecoder? = nil) throws -> T where T: Decodable {
    let decoder = decoder ?? JSONDecoder()
    return try decoder.decode(type, from: self)
  }
}
