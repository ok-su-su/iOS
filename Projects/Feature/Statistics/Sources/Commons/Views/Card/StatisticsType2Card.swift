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
  var isEmptyState: Bool
  var type: CardType

  enum CardType: Equatable {
    case oneLine(title: String, description: String)
    case twoLine(title: String, leadingDescription: String, trailingDescription: String)
  }

  init(isEmptyState: Bool, type: CardType) {
    self.isEmptyState = isEmptyState
    self.type = type
  }
}

// MARK: - StatisticsType2Card

struct StatisticsType2Card: View {
  var property: StatisticsType2CardProperty

  @ViewBuilder
  private func makeOneLineCard(title: String, description: String) -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text(title)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text(description)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(property.isEmptyState ? SSColor.blue60 : SSColor.gray40)
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(SSColor.gray10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  @ViewBuilder
  private func makeTwoLineCard(title: String, leadingDescription: String, trailingDescription: String) -> some View {
    VStack(spacing: 4) {
      // 타이틀
      Text(title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray50)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 0) {
        // leading Item

        Text(leadingDescription)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray80)

        Spacer()

        // TrailingItem
        Text(trailingDescription)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(property.isEmptyState ? SSColor.gray40 : SSColor.gray100)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  var body: some View {
    switch property.type {
    case let .oneLine(title, description):
      makeOneLineCard(title: title, description: description)
    case let .twoLine(title, leadingDescription, trailingDescription):
      makeTwoLineCard(title: title, leadingDescription: leadingDescription, trailingDescription: trailingDescription)
    }
  }
}
