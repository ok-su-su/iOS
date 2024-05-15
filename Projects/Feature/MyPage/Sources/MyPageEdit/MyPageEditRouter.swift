//
//  MyPageEditRouter.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import ComposableArchitecture
import Designsystem
import SwiftUI

final class MyPageEditRouter: UIHostingController<MyPageEditView> {
  // MARK: RouterSubscription

  var subscription: AnyCancellable? = nil

  // MARK: Reducer

  let reducer: MyPageEdit

  override func viewDidLoad() {
    super.viewDidLoad()

    subscription = reducer
      .routingPublisher
      .sink { [weak self] path in
        switch path {
        case .dismiss:
          self?.navigationController?.popViewController(animated: true)
        }
      }
  }

  init() {
    let reducer = MyPageEdit()
    self.reducer = reducer

    super.init(rootView: MyPageEditView(store: .init(initialState: MyPageEdit.State()) {
      reducer
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
