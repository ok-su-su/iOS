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
          guard let urlString = Constants.privateURLString,
                let url = URL(string: urlString)
          else {
            return
          }
          let vc = SFSafariViewController(url: url)
          self?.present(vc, animated: true)
        case .appVersion:
          self?.openAppStore()
          return
        case .logout:
          return
        case .resign:
          return
        case .feedBack:
          guard let urlString = Constants.feedBackURLString,
                let url = URL(string: urlString)
          else {
            return
          }
          let vc = SFSafariViewController(url: url)
          self?.present(vc, animated: true)
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

  private enum Constants {
    static let privateURLString: String? = Bundle(for: BundleFinder.self).infoDictionary?["PRIVACY_POLICY_URL"] as? String
    static let feedBackURLString: String? = Bundle(for: BundleFinder.self).infoDictionary?["SUSU_GOOGLE_FROM_URL"] as? String
  }

  func openAppStore() {
    #func
    guard let appID = Bundle.main.infoDictionary?["AppstoreAPPID"] as? String,
          let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
          UIApplication.shared.canOpenURL(appStoreURL)
    else {
      return
    }
    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
  }
}

// MARK: - BundleFinder

private class BundleFinder {}
