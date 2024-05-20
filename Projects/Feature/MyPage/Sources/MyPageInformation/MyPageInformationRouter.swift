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

    subscription = reducer
      .routingPublisher
      .sink { [weak self] path in
        switch path {
        // 프로필 편집 뷰로 이동
        case .editProfile:
          let vc = MyPageEditRouter()
          self?.navigationController?.pushViewController(vc, animated: true)
          return
        }
      }
  }

  var reducer: MyPageInformation
  init() {
    let reducer = MyPageInformation()
    self.reducer = reducer

    super.init(rootView: MyPageInformationView(store: .init(initialState: MyPageInformation.State()) {
      reducer
    }))
  }

  @available(*, unavailable)
  @MainActor dynamic required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
