//
//  SpecificEnvelopeHistoryListProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SpecificEnvelopeHistoryListProperty: Equatable {
  var envelopePriceProgressProperty: EnvelopePriceProgressProperty
  var envelopeContents: [EnvelopeContent]

  var alertTitleText = "모든 봉투를 삭제할까요?"
  var alertDescriptionText = "삭제한 봉투는 다시 복구할 수 없어요"
  var alertLeftButtonText = "취소"
  var alertRightButtonText = "삭제"
}
