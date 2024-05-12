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

// MARK: - TTView

struct TTView: Viewable {
  var body: some View {
    EmptyView()
  }
}

// MARK: - Viewable

protocol Viewable: View {}

// MARK: - MyPageMainRouter

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
        case .connectedSocialAccount:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        case .exportExcel:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        case .privacyPolicy:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        case .appVersion:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        case .logout:
          navigationController.pushViewController(MyPageInformationRouter(), animated: true)
        case .resign:
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
