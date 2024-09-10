//
//  InfoPlistConstants.swift
//  CommonExtension
//
//  Created by MaraMincho on 9/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum InfoPlistConstants {
  public static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
