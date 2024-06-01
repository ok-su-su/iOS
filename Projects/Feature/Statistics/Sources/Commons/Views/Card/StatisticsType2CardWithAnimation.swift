//
//  StatisticsType2CardWithAnimation.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - StatisticsType2Card

struct StatisticsType2CardWithAnimation: View {
  @Binding var property: StatisticsType2CardProperty
  @State private var oldTitle: String = ""
  @State private var newTitle: String = ""

  init(property: Binding<StatisticsType2CardProperty>) {
    _property = property
  }

  var body: some View {
    VStack(spacing: 4) {
      // 타이틀
      Text(property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray50)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 0) {
        // leading Item

        CustomNumericAnimationView(
          height: 30,
          item: $property
        ) {
          Text(oldTitle)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        } newContent: {
          Text(newTitle)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        }

        Spacer()

        // TrailingItem
        Text(property.trailingDescription)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(SSColor.gray10)
    .onChange(of: property) { oldValue, newValue in
      newTitle = newValue.leadingDescription
      oldTitle = oldValue.leadingDescription
    }
    .onAppear {
      newTitle = property.leadingDescription
      oldTitle = property.leadingDescription
    }
  }
}
