//
//  StatisticsType1Card.swift
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

// MARK: - StatisticsType1Card

struct StatisticsType1Card: View {
  var property: StatisticsType1CardProperty

  init(property: StatisticsType1CardProperty) {
    self.property = property
  }

  var body: some View {
    VStack(spacing: 8) {
      // 타이틀
      Text(property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 0) {
        // Description
        Text(property.description)
          .modifier(SSTypoModifier(.title_l))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.orange60)

        // Caption
        Text(property.caption)
          .modifier(SSTypoModifier(.text_xxxs))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray60)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}
