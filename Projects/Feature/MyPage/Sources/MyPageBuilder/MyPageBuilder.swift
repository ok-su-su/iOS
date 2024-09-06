//
//  MyPageBuilder.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct MyPageBuilderView: View {
  public init() {}
  @State var store: StoreOf<MyPageMain> = .init(initialState: .init()) {
    MyPageMain()
  }

  public var body: some View {
    MyPageMainView(store: store)
  }
}
