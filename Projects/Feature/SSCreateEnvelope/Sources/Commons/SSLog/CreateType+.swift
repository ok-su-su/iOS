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
    case .Received:
      .Received(.createEnvelope(viewType))
    case .Sent:
      .Sent(.createEnvelope(viewType))
    }
  }
}

extension CreateEnvelopeInitialType {
  func convertMarktingModuleName(viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
    switch self {
    case .Sent,
         .SentWithFriendID:
      .Sent(.createEnvelope(viewType))
    case .Received:
      .Received(.createEnvelope(viewType))
    }
  }
}

func convertMarketingModuleName(_ createType: CreateType, viewType: CreateEnvelopeMarketingModule) -> MarketingModulesMain {
  switch createType {
  case .Sent:
    .Sent(.createEnvelope(viewType))
  case .Received:
    .Received(.createEnvelope(viewType))
  }
}

func pushButtonLogEvent(_ createType: CreateEnvelopeInitialType, lastPathState state: CreateEnvelopePath.State?) {
  let createType: CreateType = switch createType {
  case .Sent,
       .SentWithFriendID:
    .Sent
  case .Received:
    .Received
  }
  switch createType {
  case .Sent:
    ssLogEvent(CreateEnvelopeSentEvents.tappedNextButtonAtCreateEnvelope(type: getViewType(state)))
  case .Received:
    break
  }
}

func finishCreateEnvelopeLogEvent(_ createType: CreateEnvelopeInitialType) {
  switch createType {
  case .Sent,
       .SentWithFriendID:
    ssLogEvent(CreateEnvelopeSentEvents.finishCreateEnvelope)
  case .Received:
    break
  }
}

func backButtonLogEvent(_ createType: CreateEnvelopeInitialType, lastPathState state: CreateEnvelopePath.State?) {
  let createType: CreateType = switch createType {
  case .Sent,
       .SentWithFriendID:
    .Sent
  case .Received:
    .Received
  }
  switch createType {
  case .Sent:
    ssLogEvent(CreateEnvelopeSentEvents.tappedBackButtonAtCreateEnvelope(type: getViewType(state)))
  case .Received:
    break
  }
}

@available(*, deprecated, renamed: "backButtonLogEvent(CreateInitailType:lastPathState:)", message: "use anthoer moethod")
func ssLogEvent(
  _ createType: CreateType,
  eventName: String = "",
  lastPathState state: CreateEnvelopePath.State?,
  eventType: SSLogEventType
) {
  let marketingModuleName = convertMarketingModuleName(createType, viewType: getViewType(state))
  SSFirebase.ssLogEvent(marketingModuleName, eventName: eventName, eventType: eventType)
}

private func getViewType(_ lastPathState: CreateEnvelopePath.State?) -> CreateEnvelopeViewTypes {
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
    .selectAdditional
  case .createEnvelopeAdditionalMemo:
    .memo
  case .createEnvelopeAdditionalContact:
    .phoneNumber
  case .createEnvelopeAdditionalIsGift:
    .gift
  case .createEnvelopeAdditionalIsVisitedEvent:
    .isVisited
  // 첫 화면에서 요청한 경우 price로 넘어가게 됩니다.
  case .none:
    .price
  }
}

private func getViewType(_ lastPathState: CreateEnvelopePath.State?) -> CreateEnvelopeMarketingModule {
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
