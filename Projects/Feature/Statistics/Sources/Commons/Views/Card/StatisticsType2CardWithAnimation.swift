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

// MARK: - StatisticsType2CardWithAnimationProperty

struct StatisticsType2CardWithAnimationProperty: Equatable {
  var title: String
  var leadingDescription: String
  private var trailingDescription: String
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
  }

  mutating func updateTrailingText(_ value: String) {
    if value.isEmpty {
      return
    }
    trailingDescription = value
    let num = Int(String(trailingDescription.compactMap(\.wholeNumberValue).map { String($0) }.joined()))!
    trailingDescriptionSlice = formatter.string(from: .init(value: num))!.map { String($0) }
  }
}

// MARK: - StatisticsType2CardWithAnimation

struct StatisticsType2CardWithAnimation: View {
  @Binding var property: StatisticsType2CardWithAnimationProperty
  @State private var oldLeadingTitle: String = ""
  @State private var newLeadingTitle: String = ""
  @State private var oldTrailingTitle: [String] = []
  @State private var newTrailingTitle: [String] = []

  init(property: Binding<StatisticsType2CardWithAnimationProperty>) {
    _property = property
  }

  @ViewBuilder
  func makeTrailingItem() -> some View {
    CustomNumericNumberView(
      descriptionSlice: $property.trailingDescriptionSlice,
      isEmptyState: false,
      height: 30
    )
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
