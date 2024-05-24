//
//  StatisticsInformationHalfWidthView.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - StatisticsType1CardProperty

struct StatisticsType1CardProperty: Equatable {
  var title: String
  var description: String
  var caption: String
  var isEmptyState: Bool
}

// MARK: - StatisticsType0Card

struct StatisticsType0Card: View {
  var property: StatisticsType1CardProperty

  init(property: StatisticsType1CardProperty) {
    self.property = property
  }

  var body: some View {
    VStack(spacing: 0) {
      // 타이틀
      Text(property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)

      VStack(spacing: 0) {
        // Description
        Text(property.description)
          .modifier(SSTypoModifier(.title_l))
          .foregroundStyle(SSColor.orange60)

        // Caption
        Text(property.caption)
          .modifier(SSTypoModifier(.text_xxxxs))
          .foregroundStyle(SSColor.gray60)
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(SSColor.gray10)
    }
  }
}
