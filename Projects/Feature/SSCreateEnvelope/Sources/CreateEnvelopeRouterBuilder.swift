//
//  CreateEnvelopeRouterBuilder.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
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
    currentType: CreateType,
    initialCreateEnvelopeRequestBody: CreateEnvelopeRequestBody,
    completion: @escaping (Data) -> Void
  ) {
    CreateEnvelopeRequestShared.setBody(initialCreateEnvelopeRequestBody)
    self.currentType = currentType
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

// MARK: - CreateType

public enum CreateType: Equatable {
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
}
