//
//  SSNotificationName.swift
//  SSNotification
//
//  Created by MaraMincho on 8/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum SSNotificationName {
  public static let tappedEnveloped = Notification.Name("TappedEnveloped")
  public static let tappedInventory = Notification.Name("tappedInventory")
  public static let tappedStatistics = Notification.Name("tappedStatistics")
  public static let tappedVote = Notification.Name("tappedVote")
  public static let tappedMyPage = Notification.Name("tappedMyPage")
  public static let goMainScene = Notification.Name("goMainScene")

  public static let logout = Notification.Name("logout")

  public static let goMyPageEditMyProfile = Notification.Name("goMyPageEditMyProfile")
  public static let goEditProfile = Notification.Name("goEditProfile")

  public static let showDefaultNetworkErrorAlert = Notification.Name("ShowDefaultNetworkErrorAlert")
  public static let logError = Notification.Name("ErrorLog")
}
