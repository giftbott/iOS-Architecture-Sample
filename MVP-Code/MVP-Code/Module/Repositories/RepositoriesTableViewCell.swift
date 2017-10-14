//
//  RepositoriesTableViewCell.swift
//  MVC-Code
//
//  Created by giftbot on 2017. 9. 27..
//  Copyright © 2017년 giftbot. All rights reserved.
//

import UIKit

protocol RepositoriesCellType {
  func configureWith(name: String, description: String?, star: Int, fork: Int)
}

final class RepositoriesTableViewCell: UITableViewCell, RepositoriesCellType {
  
  // MARK: - Properties
  
  static let identifier = String(describing: RepositoriesTableViewCell.self)
  
  private let nameLabel = UILabel()
  private let descLabel = UILabel()
  private let starImageView = UIImageView(image: #imageLiteral(resourceName: "img_star"))
  private let starLabel = UILabel()
  private let forkImageView = UIImageView(image: #imageLiteral(resourceName: "img_fork"))
  private let forkLabel = UILabel()
  
  // MARK: - UI Metrics
  
  private struct UI {
    static let baseMargin = CGFloat(8)
    static let imageSize = CGSize(width: 15, height: 15)
    static let countLabelSize = CGSize(width: 50, height: UI.imageSize.height)
  }
  
  // MARK: - Initialize
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    nameLabel.lineBreakMode = .byTruncatingHead
    nameLabel.font = .preferredFont(forTextStyle: .headline)
    
    descLabel.numberOfLines = 0
    descLabel.lineBreakMode = .byWordWrapping
    descLabel.font = .preferredFont(forTextStyle: .caption1)
    
    starLabel.font = .preferredFont(forTextStyle: .footnote)
    forkLabel.font = .preferredFont(forTextStyle: .footnote)
    
    contentView.addSubviews([nameLabel, descLabel, starImageView, starLabel, forkImageView, forkLabel])
  }
  
  private func setupConstraints() {
    nameLabel
      .topAnchor(to: contentView.topAnchor, constant: UI.baseMargin)
      .leadingAnchor(to: contentView.leadingAnchor, constant: UI.baseMargin)
      .trailingAnchor(to: contentView.trailingAnchor, constant: -UI.baseMargin)
      .activateAnchors()
    
    descLabel
      .topAnchor(to: nameLabel.bottomAnchor, constant: UI.baseMargin)
      .leadingAnchor(to: nameLabel.leadingAnchor)
      .trailingAnchor(to: nameLabel.trailingAnchor)
      .activateAnchors()
    descLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: UILayoutConstraintAxis.vertical)
    
    starImageView
      .topAnchor(to: descLabel.bottomAnchor, constant: UI.baseMargin)
      .leadingAnchor(to: nameLabel.leadingAnchor)
      .bottomAnchor(to: contentView.bottomAnchor, constant: -UI.baseMargin)
      .dimensionAnchors(size: UI.imageSize)
      .activateAnchors()
    
    starLabel
      .centerYAnchor(to: starImageView.centerYAnchor)
      .leadingAnchor(to: starImageView.trailingAnchor, constant: UI.baseMargin)
      .dimensionAnchors(size: UI.countLabelSize)
      .activateAnchors()
    
    forkImageView
      .centerYAnchor(to: starImageView.centerYAnchor)
      .leadingAnchor(to: starLabel.trailingAnchor, constant: UI.baseMargin)
      .dimensionAnchors(size: UI.imageSize)
      .activateAnchors()
    
    forkLabel
      .centerYAnchor(to: forkImageView.centerYAnchor)
      .leadingAnchor(to: forkImageView.trailingAnchor, constant: UI.baseMargin)
      .dimensionAnchors(size: UI.countLabelSize)
      .activateAnchors()
  }
  
  // MARK: - Cell Contents
  
  func configureWith(name: String, description: String?, star: Int, fork: Int) {
    nameLabel.text = name
    descLabel.text = description ?? ""
    starLabel.text = String(describing: star)
    forkLabel.text = String(describing: fork)
  }
}
