//
//  CustomNumericAnimationView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - CustomNumericAnimationDirection

enum CustomNumericAnimationDirection {
  case upper(duration: Double = 0.07)
  case down(duration: Double = 0.07)

  var duration: Double {
    switch self {
    case let .upper(duration):
      duration
    case let .down(duration):
      duration
    }
  }

  var directionWeight: Double {
    switch self {
    case .upper:
      1
    case .down:
      -1
    }
  }
}

// MARK: - CustomNumericAnimationView

struct CustomNumericAnimationView<Item, OldContent, NewContent>: View where OldContent: View, NewContent: View, Item: Equatable {
  private var oldContent: OldContent
  private var newContent: NewContent
  private var direction: CustomNumericAnimationDirection

  @Binding private var item: Item
  @State private var oldOffset = 0.0
  @State private var newOffset = 0.0

  private var moveHeightOffset: CGFloat
  var height: CGFloat
  init(
    height: CGFloat,
    item: Binding<Item>,
    direction: CustomNumericAnimationDirection = .upper(duration: 0.3),
    @ViewBuilder oldContent: () -> OldContent,
    @ViewBuilder newContent: () -> NewContent
  ) {
    self.height = height
    self.oldContent = oldContent()
    self.newContent = newContent()
    self.direction = direction
    _item = item
    newOffset = height
    moveHeightOffset = height
  }

  var body: some View {
    ZStack {
      oldContent
        .offset(y: oldOffset)
      newContent
        .offset(y: newOffset)
    }
    .frame(height: height)
    .clipped()
    .onChange(of: item) { _, _ in
      oldOffset = 0
      newOffset = moveHeightOffset * direction.directionWeight
      withAnimation(.easeInOut(duration: direction.duration)) {
        oldOffset = -moveHeightOffset * direction.directionWeight
        newOffset = 0
      }
    }
  }
}
