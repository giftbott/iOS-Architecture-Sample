//
//  UIView+LayoutAnchor.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 10. 4..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

// NSLayoutAnchor Helper

extension UIView {
  func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
    topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  
  func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
    leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  
  func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
    bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  
  func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
    trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  
  func widthAnchor(constant: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  func heightAnchor(constant: CGFloat) -> Self {
    heightAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  func dimensionAnchors(width widthConstant: CGFloat, height heightConstant: CGFloat) -> Self {
    widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
    heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
    return self
  }
  
  func dimensionAnchors(size: CGSize) -> Self {
    widthAnchor.constraint(equalToConstant: size.width).isActive = true
    heightAnchor.constraint(equalToConstant: size.height).isActive = true
    return self
  }
  
  func centerYAnchor(to anchor: NSLayoutYAxisAnchor) -> Self {
    centerYAnchor.constraint(equalTo: anchor).isActive = true
    return self
  }
  
  func centerXAnchor(to anchor: NSLayoutXAxisAnchor) -> Self {
    centerXAnchor.constraint(equalTo: anchor).isActive = true
    return self
  }
  
  func activateAnchors() {
    translatesAutoresizingMaskIntoConstraints = false
  }
}
