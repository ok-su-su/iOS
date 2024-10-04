//
//  MyPageRouterAndPathPublisher.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

final class MyPageRouterAndPathPublisher {
  private nonisolated(unsafe) static let shared = MyPageRouterAndPathPublisher()
  private init() {}
  private var _pathPublisher: PassthroughSubject<MyPageNavigationPath.State, Never> = .init()
  static var pathPublisher: AnyPublisher<MyPageNavigationPath.State, Never> {
    shared._pathPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  private var _routingPublisher: PassthroughSubject<MyPageRouterPath, Never> = .init()
  static var routingPublisher: AnyPublisher<MyPageRouterPath, Never> {
    shared._routingPublisher.receive(on: RunLoop.main).eraseToAnyPublisher()
  }

  static func push(_ pathState: MyPageNavigationPath.State) {
    shared._pathPublisher.send(pathState)
  }

  static func route(_ current: MyPageRouterPath) {
    shared._routingPublisher.send(current)
  }
}
