//
//  ProfileMainRouter.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

final class MyPageMainRouter: UIHostingController<MyPageMainView> {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  init() {
    super.init(rootView: MyPageMainView(store: .init(initialState: MyPageMain.State()) {
      MyPageMain()
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
