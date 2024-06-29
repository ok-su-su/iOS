//
//  InventoryPreview.swift
//  StatisticsPreview
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Inventory
import SwiftUI

@main
struct InventoryPreviewMain: App {
  init() {
    Font.registerFont()
  }

  var body: some Scene {
    WindowGroup {
      InventoryBuilderView()
    }
  }
}
