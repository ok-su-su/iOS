//
//  MyPageInformationRouter.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class MyPageInformationRouter: UIHostingController<MyPageInformationView> {
  var subscription: AnyCancellable? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  init() {
    let reducer = MyPageInformation()

    super.init(rootView: MyPageInformationView(store: .init(initialState: MyPageInformation.State()) {
      reducer
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
