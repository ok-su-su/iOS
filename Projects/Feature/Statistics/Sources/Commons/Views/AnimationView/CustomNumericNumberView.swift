//
//  CustomNumericNumberView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

struct CustomNumericNumberView: View {
  @Binding var descriptionSlice: [String]
  @State private var oldTrailingTitle: [String] = []
  @State private var newTrailingTitle: [String] = []

  var isEmptyState: Bool
  var height: CGFloat

  init(descriptionSlice: Binding<[String]>, isEmptyState: Bool, height: CGFloat) {
    _descriptionSlice = descriptionSlice
    self.isEmptyState = isEmptyState
    self.height = height
  }

  var body: some View {
    HStack(spacing: 0) {
      ForEach(0 ..< descriptionSlice.count, id: \.self) { ind in
        let oldContentText = ind < oldTrailingTitle.count ? oldTrailingTitle[ind] : ""
        let newContentText = ind < newTrailingTitle.count ? newTrailingTitle[ind] : ""
        CustomNumericNumberAnimation(
          height: height,
          item: $descriptionSlice[ind]
        ) {
          Text(newContentText == "," ? "" : oldContentText)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(isEmptyState ? SSColor.gray40 : SSColor.gray80)
        } newContent: {
          Text(newContentText)
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(isEmptyState ? SSColor.gray40 : SSColor.gray80)
        }
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
