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
    store = .init(
      initialState: .init(type: currentType)) {
        CreateEnvelopeRouter()
      }

    CreateEnvelopeRequestShared.setBody(.init(type: currentType.toCreateType))
    switch currentType {
    case let .sentWithFriendID(friendID, friendName):
      CreateEnvelopeRequestShared.setFriendID(id: friendID)
      CreateFriendRequestShared.setName(friendName)

    case let .received(ledgerID, categoryName):
      CreateEnvelopeRequestShared.setCategoryName(categoryName)
      CreateEnvelopeRequestShared.setLedger(id: ledgerID)

    case .sent:
      break
    }
  }

  public var body: some View {
    CreateEnvelopeRouterView(store: store, completion: completion)
  }
}

// MARK: - CreateEnvelopeInitialType

public enum CreateEnvelopeInitialType: Equatable {
  case sentWithFriendID(friendID: Int64, friendName: String)
  case sent
  case received(ledgerID: Int64, categoryName: String)

  var toCreateType: CreateType {
    switch self {
    case .sent,
         .sentWithFriendID:
      .sent
    case .received:
      .received
    }
  }
}

// MARK: - CreateType

enum CreateType: Equatable, CaseIterable {
  case sent
  case received

  var key: String {
    switch self {
    case .sent:
      return "SENT"
    case .received:
      return "RECEIVED"
    }
  }

  static func getTypeBy(_ val: String?) -> Self? {
    guard let val else {
      return nil
    }
    return CreateType.allCases.first { $0.key == val }
  }
}
