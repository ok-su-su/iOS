//
//  CreateType+.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 9/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSFirebase

extension CreateType {
  func convertMarktingModuleName(viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
    switch self {
    case .received:
      .Received(.createEnvelope(viewType))
    case .sent:
      .Sent(.createEnvelope(viewType))
    }
  }
}

func convertMarketingModuleName(_ createType: CreateType, viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
  switch createType {
  case .sent:
    .Sent(.createEnvelope(viewType))
  case .received:
    .Received(.createEnvelope(viewType))
  }
}

func ssLogEvent(
  _ createType: CreateType,
  eventName: String = "",
  lastPathState state: CreateEnvelopePath.State?,
  eventType: SSLogEventType
) {
  let marketingModuleName = convertMarketingModuleName(createType, viewType: .getViewType(lastPathState: state))
  SSFirebase.ssLogEvent(marketingModuleName, eventName: eventName, eventType: eventType)
}

extension CreateEnvelopeMarketingModule {
  static func getViewType(lastPathState: CreateEnvelopePath.State?) -> Self {
    switch lastPathState {
    case .createEnvelopePrice:
      .price
    case .createEnvelopeName:
      .name
    case .createEnvelopeRelation:
      .relation
    case .createEnvelopeEvent:
      .category
    case .createEnvelopeDate:
      .date
    case .createEnvelopeAdditionalSection:
      .additionalSection
    case .createEnvelopeAdditionalMemo:
      .memo
    case .createEnvelopeAdditionalContact:
      .contact
    case .createEnvelopeAdditionalIsGift:
      .gift
    case .createEnvelopeAdditionalIsVisitedEvent:
      .isVisited
    // 첫 화면에서 요청한 경우 price로 넘어가게 됩니다.
    case .none:
      .price
    }
  }
}
