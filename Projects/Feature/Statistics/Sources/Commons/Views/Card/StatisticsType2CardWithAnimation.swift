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

struct StatisticsType2CardWithAnimationProperty: Equatable, Sendable {
  var title: String
  var leadingDescription: String
  private var trailingDescription: String
  var isEmptyState: Bool
  var trailingDescriptionSlice: [String]
  var formatter = NumberFormatter()
  var subfixString: String
  init(title: String, leadingDescription: String, trailingDescription: String, isEmptyState: Bool, subfixString: String = "") {
    self.title = title
    self.leadingDescription = leadingDescription
    self.trailingDescription = trailingDescription
    self.isEmptyState = isEmptyState
    self.subfixString = subfixString

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

  let textColor: Color
  let emptyStateTextColor: Color
  var animationDuration: Double

  init(property: Binding<StatisticsType2CardWithAnimationProperty>, animationDuration: Double = 0.3, textColor: Color = SSColor.gray80,
       emptyStateTextColor: Color = SSColor.gray40) {
    _property = property
    self.textColor = textColor
    self.animationDuration = animationDuration
    self.emptyStateTextColor = emptyStateTextColor
  }

  @ViewBuilder
  func makeTrailingItem() -> some View {
    CustomNumericNumberView(
      descriptionSlice: $property.trailingDescriptionSlice,
      animationDuration: animationDuration,
      isEmptyState: false,
      height: 30,
      subFixString: property.subfixString,
      textColor: textColor,
      emptyStateTextColor: emptyStateTextColor
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
          item: $property,
          direction: .upper(duration: animationDuration)
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
    .clipShape(RoundedRectangle(cornerRadius: 4))
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
