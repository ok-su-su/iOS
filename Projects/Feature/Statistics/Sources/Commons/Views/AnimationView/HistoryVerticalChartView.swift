//
//  HistoryVerticalChartView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - HistoryVerticalChartView

struct HistoryVerticalChartView: View {
  var historyHeights: [HistoryChartProperty]
  var chartTitle: String
  var chartTopTrailingDescription: String
  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text(chartTitle)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text(chartTopTrailingDescription)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.blue60)
        // TODO: - Empty일 떄 로직 세우기
//          .foregroundColor(isData ? SSColor.blue60 : SSColor.gray40)
      }

      HStack(spacing: 12) {
        ForEach(0 ..< historyHeights.count, id: \.self) { ind in
          let curData = historyHeights[ind]
          VStack(spacing: 4) {
            Spacer()
            SSColor
              .orange30
              .frame(maxWidth: 24, maxHeight: CGFloat(curData.height))
              .clipShape(RoundedRectangle(cornerRadius: 4))

            Text(curData.caption)
              .modifier(SSTypoModifier(.title_xxxs))
              .foregroundStyle(SSColor.gray40)
          }
          .frame(maxWidth: 24, minHeight: 104)
        }
      }
    }
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}

// MARK: - HistoryChartProperty

struct HistoryChartProperty: Identifiable {
  let id: Int
  let height: CGFloat
  let caption: String
}
