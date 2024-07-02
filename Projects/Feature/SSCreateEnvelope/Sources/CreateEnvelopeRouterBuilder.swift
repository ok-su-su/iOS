//
//  CreateEnvelopeRouterBuilder.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - CreateEnvelopeRouterBuilder

public struct CreateEnvelopeRouterBuilder: View {
  private var currentType: CreateType
  public init(currentType: CreateType) {
    self.currentType = currentType
  }

  public var body: some View {
    CreateEnvelopeRouterView(store: .init(initialState: .init(type: currentType), reducer: {
      CreateEnvelopeRouter()
    }))
  }
}

// MARK: - CreateType

public enum CreateType {
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
