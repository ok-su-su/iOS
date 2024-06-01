//
//  StatisticsType2Card.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - StatisticsType2CardProperty

struct StatisticsType2CardProperty: Equatable {
  var title: String
  var leadingDescription: String
  var trailingDescription: String
  var isEmptyState: Bool
  var trailingDescriptionSlice: [String]
  var formatter = NumberFormatter()
  init(title: String, leadingDescription: String, trailingDescription: String, isEmptyState: Bool) {
    self.title = title
    self.leadingDescription = leadingDescription
    self.trailingDescription = trailingDescription
    self.isEmptyState = isEmptyState

    formatter.numberStyle = .decimal

    trailingDescriptionSlice = []
    updateTrailingText(trailingDescription)
    // TODO: force unwrapping 제거
  }

  mutating func updateTrailingText(_ value: String) {
    trailingDescription = value
    let num = Int(String(trailingDescription.compactMap(\.wholeNumberValue).map { String($0) }.joined()))!
    trailingDescriptionSlice = formatter.string(from: .init(value: num))!.map { String($0) }
  }
}

// MARK: - StatisticsType2Card

struct StatisticsType2Card: View {
  var property: StatisticsType2CardProperty

  var body: some View {
    VStack(spacing: 4) {
      // 타이틀
      Text(property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray50)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 0) {
        // leading Item

        Text(property.leadingDescription)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)

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
  }
}
