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
  ///   - initialCreateEnvelopeRequestBody: Set InitialOfCreateEnvelopeBody Value
  ///   - completion: run when createEnvelopeRouterBuild dismiss
  public init(
    currentType: CreateEnvelopeInitialType,
    initialCreateEnvelopeRequestBody: CreateEnvelopeRequestBody,
    completion: @escaping (Data) -> Void
  ) {
    CreateEnvelopeRequestShared.setBody(initialCreateEnvelopeRequestBody)
    self.currentType = currentType.toCreateType
    self.completion = completion
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

public enum CreateEnvelopeInitialType: Equatable {
  case sentWithFriendID(Int64)
  case sent
  case received

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

public enum CreateType: Equatable, CaseIterable {
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
