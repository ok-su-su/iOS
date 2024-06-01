//
//  CustomNumericAnimationView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - CustomNumericAnimationView

struct CustomNumericAnimationView<Item, OldContent, NewContent>: View where OldContent: View, NewContent: View, Item: Equatable {
  private var oldContent: OldContent
  private var newContent: NewContent
  @Binding private var item: Item
  @State private var oldOffset = 0.0
  @State private var newOffset = 0.0

  private var moveHeightOffset: CGFloat
  var height: CGFloat
  init(
    height: CGFloat,
    item: Binding<Item>,
    @ViewBuilder oldContent: () -> OldContent,
    @ViewBuilder newContent: () -> NewContent
  ) {
    self.height = height
    self.oldContent = oldContent()
    self.newContent = newContent()
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
      newOffset = moveHeightOffset
      withAnimation(.linear(duration: 0.05)) {
        oldOffset = -moveHeightOffset
        newOffset = 0
      }
//    completion: {
//      oldOffset = 0
//      newOffset = moveHeightOffset
//    }
    }
  }
}
