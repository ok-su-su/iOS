//
//  CustomNumericNumberView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - CustomNumericNumberView

struct CustomNumericNumberView: View {
  @Binding var descriptionSlice: [String]
  @State private var oldTrailingTitle: [String] = []
  @State private var newTrailingTitle: [String] = []

  var isEmptyState: Bool
  var height: CGFloat
  var textColor: Color
  var emptyStateTextColor: Color
  var subFixString: String
  private var animationDuration: Double

  init(
    descriptionSlice: Binding<[String]>,
    animationDuration: Double = 0.6,
    isEmptyState: Bool,
    height: CGFloat,
    subFixString: String = "",
    textColor: Color = SSColor.gray80,
    emptyStateTextColor: Color = SSColor.gray40
  ) {
    _descriptionSlice = descriptionSlice
    self.isEmptyState = isEmptyState
    self.height = height
    self.textColor = textColor
    self.emptyStateTextColor = emptyStateTextColor
    self.subFixString = subFixString
    self.animationDuration = animationDuration
  }

  var body: some View {
    HStack(spacing: 0) {
      ForEach(0 ..< descriptionSlice.count, id: \.self) { ind in
        let oldContentText = ind < oldTrailingTitle.count ? oldTrailingTitle[ind] : ""
        let newContentText = ind < newTrailingTitle.count ? newTrailingTitle[ind] : ""
        CustomNumericNumberAnimation(
          height: height,
          item: $descriptionSlice[ind],
          duration: animationDuration
        ) {
          Text(newContentText == "," ? "" : oldContentText)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(isEmptyState ? emptyStateTextColor : textColor)
        } newContent: {
          Text(newContentText)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(isEmptyState ? emptyStateTextColor : textColor)
        }
      }
      if !subFixString.isEmpty {
        Text(subFixString)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(isEmptyState ? emptyStateTextColor : textColor)
      }
    }
    .onAppear {
      newTrailingTitle = descriptionSlice
      oldTrailingTitle = descriptionSlice
    }
    .onChange(of: descriptionSlice) { oldValue, newValue in
      newTrailingTitle = newValue
      oldTrailingTitle = oldValue
    }
  }
}
