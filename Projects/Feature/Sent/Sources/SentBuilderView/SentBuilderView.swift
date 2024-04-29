//
//  SentBuilderView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

public struct SentBuilderView: View {
  public init() {}
  public var body: some View {
    SentMainView(store: .init(initialState: SentMain.State()) {
      SentMain()
    })
  }
}
