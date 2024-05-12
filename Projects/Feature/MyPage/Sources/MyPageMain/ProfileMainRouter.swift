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
    subscription = reducer.routingPublisher
      .sink { [weak self] path in
        switch path {
        case .myPageInformation:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .connectedSocialAccount:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .exportExcel:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .privacyPolicy:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .appVersion:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .logout:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .resign:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        }
      }
  }

  let reducer: MyPageMain
  init() {
    let reducer = MyPageMain()
    self.reducer = reducer
    super.init(rootView: MyPageMainView(store: .init(initialState: MyPageMain.State()) {
      reducer
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
