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

  private var completion: (Data) -> Void
  public init(currentType: CreateType, completion: @escaping (Data) -> Void) {
    self.currentType = currentType
    self.completion = completion
  }

  public var body: some View {
    CreateEnvelopeRouterView(store: .init(initialState: .init(type: currentType), reducer: {
      CreateEnvelopeRouter()
    }), completion: completion)
  }
}

// MARK: - CreateType

public enum CreateType: Equatable {
  case sent
  case received(ledgerId: Int64)

  var key: String {
    switch self {
    case .sent:
      return "SENT"
    case .received:
      return "RECEIVED"
    }
  }
}
