//
//  ProfileMainRouter.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import OSLog
import SwiftUI

final class MyPageMainRouter: UIHostingController<MyPageMainView> {
  var subscription: AnyCancellable? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  init(navigationController: UINavigationController) {
    let reducer = MyPageMain()
    subscription = reducer.routingPublisher
      .sink { path in
        switch path {
        case .myPageInformation:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        }
      }

    super.init(rootView: MyPageMainView(store: .init(initialState: MyPageMain.State()) {
      reducer
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
