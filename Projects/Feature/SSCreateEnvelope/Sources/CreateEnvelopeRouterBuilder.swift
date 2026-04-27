//
//  CreateEnvelopeRouterBuilder.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SSFirebase
import SwiftUI

// MARK: - CreateEnvelopeRouterBuilder

public struct CreateEnvelopeRouterBuilder: View {
  private var currentType: CreateType

  private var completion: (Data) -> Void

  @Bindable
  var store: StoreOf<CreateEnvelopeRouter>

  /// CreateEnvelopeView
  /// - Parameters:
  ///   - currentType: Sent, Received
  ///   - completion: run when createEnvelopeRouterBuild dismiss
  public init(
    currentType: CreateEnvelopeInitialType,
    completion: @escaping (Data) -> Void
  ) {
    self.currentType = currentType.toCreateType
    self.completion = completion

    CreateEnvelopeRequestShared.setBody(.init(type: currentType.toCreateType))
    switch currentType {
    case let .SentWithFriendID(friendID, friendName):
      CreateEnvelopeRequestShared.setFriendID(id: friendID)
      CreateFriendRequestShared.setName(friendName)

    case let .Received(ledgerID, categoryName):
      CreateEnvelopeRequestShared.setCategoryName(categoryName)
      CreateEnvelopeRequestShared.setLedger(id: ledgerID)

    case .Sent:
      break
    }

    store = .init(
      initialState: .init(type: currentType)) {
        CreateEnvelopeRouter()
      }
  }

  public var body: some View {
    CreateEnvelopeRouterView(store: store, completion: completion)
  }
}

// MARK: - CreateEnvelopeInitialType

public enum CreateEnvelopeInitialType: Equatable, Sendable {
  case SentWithFriendID(friendID: Int64, friendName: String)
  case Sent
  case Received(ledgerID: Int64, categoryName: String)

  var toCreateType: CreateType {
    switch self {
    case .Sent,
         .SentWithFriendID:
      .Sent
    case .Received:
      .Received
    }
  }
}

// MARK: - CreateType

enum CreateType: Equatable, CaseIterable, CustomStringConvertible {
  case Sent
  case Received

  var key: String {
    switch self {
    case .Sent:
      return "SENT"
    case .Received:
      return "RECEIVED"
    }
  }

  static func getTypeBy(_ val: String?) -> Self? {
    guard let val else {
      return nil
    }
    return CreateType.allCases.first { $0.key == val }
  }

  var description: String {
    switch self {
    case .Sent:
      "보내요"
    case .Received:
      "받아요"
    }
  }
}
