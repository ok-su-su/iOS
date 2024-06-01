//
//  CustomNumericNumberAnimation.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - CustomNumericNumberAnimation

struct CustomNumericNumberAnimation<OldContent, NewContent>: View where OldContent: View, NewContent: View {
  private var oldContent: OldContent
  private var newContent: NewContent
  private var duration: Double

  @Binding private var item: String
  @State private var oldOffset = 0.0
  @State private var newOffset = 0.0

  private var moveHeightOffset: CGFloat
  var height: CGFloat
  init(
    height: CGFloat,
    item: Binding<String>,
    duration: Double = 0.07,
    @ViewBuilder oldContent: () -> OldContent,
    @ViewBuilder newContent: () -> NewContent
  ) {
    self.height = height
    self.oldContent = oldContent()
    self.newContent = newContent()
    self.duration = duration
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
    .onChange(of: item) { oldValue, newValue in
      guard
        oldValue != newValue,
        let oldValue = Int(oldValue),
        let newValue = Int(newValue)
      else {
        return
      }
      let directionWeight: Double = oldValue > newValue ? 1 : -1

      oldOffset = 0
      newOffset = moveHeightOffset * directionWeight
      withAnimation(.linear(duration: duration)) {
        oldOffset = -moveHeightOffset * directionWeight
        newOffset = 0
      }
    }
  }
}
