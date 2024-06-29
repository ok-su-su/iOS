//
//  ProfileMainRouter.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import OSLog
import SafariServices
import SwiftUI

// MARK: - MyPageMainRouter

final class MyPageMainRouter: UIHostingController<MyPageMainView> {
  var subscription: AnyCancellable? = nil

  let reducer: MyPageMain

  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: 트러블 슈팅 작성
    navigationController?.setNavigationBarHidden(true, animated: false)
    subscription = reducer.routingPublisher
      .sink { [weak self] path in
        switch path {
        case .myPageInformation:
          self?.navigationController?.pushViewController(MyPageInformationRouter(), animated: true)
        case .connectedSocialAccount:
          return
        case .exportExcel:
          return
        case .privacyPolicy:
          let vc = SFSafariViewController(url: .init(string: "https://sites.google.com/view/team-oksusu/%ED%99%88")!)
          self?.navigationController?.pushViewController(vc, animated: true)
        case .appVersion:
          return
        case .logout:
          return
        case .resign:
          return
        case .feedBack:
          let vc = SFSafariViewController(url: .init(string: "https://forms.gle/FHky26kAQdde9RcD7")!)
          self?.navigationController?.pushViewController(vc, animated: true)
        }
      }
  }

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
