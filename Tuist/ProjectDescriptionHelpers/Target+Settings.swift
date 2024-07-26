//
//  Target+Settings.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 7/25/24.
//

import Foundation
import ProjectDescription


extension Settings {
  static var `default`: Self {
    .settings(
      base: [
        "DEVELOPMENT_TEAM": "2G5Z92682P",
        "ENABLE_USER_SCRIPT_SANDBOXING": "No", // SandBoxingError
        "ENABLE_MODULE_VERIFIER": "No", // Enable module Verifier
        "MODULE_VERIFIER_SUPPORTED_LANGUAGES": "No",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym", // For Firebase
        "OTHER_LDFLAGS": "$(inherited) -ObjC", // For Firebase ,
        "LD_VERIFY_BITCODE" : "No"
        //        "CLANG_ENABLE_MODULES": "Yes"
      ],

      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )
  }
}
