//
//  SpecificEnvelopeHistoryRouterHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SpecificEnvelopeHistoryRouterHelper: Equatable {
  var specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty
  var envelopeHistoryEditHelper: SpecificEnvelopeHistoryEditHelper

  // TODO: API Logic
  init() {
    specificEnvelopeHistoryListProperty = .init(
      envelopePriceProgressProperty: .makeFakeData(),
      envelopeContents: (0 ..< 100).map { _ in return .fakeData() }
    )
    envelopeHistoryEditHelper = .init(envelopeDetailProperty: .fakeData())
  }

  init(
    specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty,
    envelopeHistoryEditHelper: SpecificEnvelopeHistoryEditHelper
  ) {
    self.specificEnvelopeHistoryListProperty = specificEnvelopeHistoryListProperty
    self.envelopeHistoryEditHelper = envelopeHistoryEditHelper
  }
}
