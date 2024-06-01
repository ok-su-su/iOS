//
//  StatisticsType2CardWithAnimation.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import OSLog
import SwiftUI

// MARK: - StatisticsType2Card

struct StatisticsType2CardWithAnimation: View {
  @Binding var property: StatisticsType2CardProperty
  @State private var oldLeadingTitle: String = ""
  @State private var newLeadingTitle: String = ""
  @State private var oldTrailingTitle: [String] = []
  @State private var newTrailingTitle: [String] = []

  init(property: Binding<StatisticsType2CardProperty>) {
    _property = property
  }

  @ViewBuilder
  func makeTrailingItem() -> some View {
    ForEach(0 ..< property.trailingDescriptionSlice.count, id: \.self) { ind in
      CustomNumericNumberAnimation(
        height: 30,
        item: $property.trailingDescriptionSlice[ind]
      ) {
        if ind < oldTrailingTitle.count {
          Text(oldTrailingTitle[ind])
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        }

      } newContent: {
        if ind < newTrailingTitle.count {
          Text(newTrailingTitle[ind])
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        }
      }
    }
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
          Text(oldLeadingTitle)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        } newContent: {
          Text(newLeadingTitle)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)
        }

        Spacer()
        HStack(spacing: 0) {
          makeTrailingItem()
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(SSColor.gray10)
    .onChange(of: property) { oldValue, newValue in
      newLeadingTitle = newValue.leadingDescription
      oldLeadingTitle = oldValue.leadingDescription

      newTrailingTitle = newValue.trailingDescriptionSlice
      oldTrailingTitle = oldValue.trailingDescriptionSlice
    }
    .onAppear {
      newLeadingTitle = property.leadingDescription
      oldLeadingTitle = property.leadingDescription

      newTrailingTitle = property.trailingDescriptionSlice
      oldTrailingTitle = property.trailingDescriptionSlice
    }
  }
}
