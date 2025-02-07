//
//  WrappingHStack.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

public struct WrappingHStack: Layout {
  /// inspired by: https://stackoverflow.com/a/75672314
  private var horizontalSpacing: CGFloat
  private var verticalSpacing: CGFloat
  public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat? = nil) {
    self.horizontalSpacing = horizontalSpacing
    self.verticalSpacing = verticalSpacing ?? horizontalSpacing
  }

  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
    guard !subviews.isEmpty else { return .zero }

    let height = subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0

    var rowWidths = [CGFloat]()
    var currentRowWidth: CGFloat = 0
    for subview in subviews {
      if currentRowWidth + horizontalSpacing + subview.sizeThatFits(proposal).width >= proposal.width ?? 0 {
        rowWidths.append(currentRowWidth)
        currentRowWidth = subview.sizeThatFits(proposal).width
      } else {
        currentRowWidth += horizontalSpacing + subview.sizeThatFits(proposal).width
      }
    }
    rowWidths.append(currentRowWidth)

    let rowCount = CGFloat(rowWidths.count)
    return CGSize(width: max(rowWidths.max() ?? 0, proposal.width ?? 0), height: rowCount * height + (rowCount - 1) * verticalSpacing)
  }

  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
    let height = subviews.map { $0.dimensions(in: proposal).height }.max() ?? 0
    guard !subviews.isEmpty else { return }
    var x = bounds.minX
    var y = height / 2 + bounds.minY
    for subview in subviews {
      x += subview.dimensions(in: proposal).width / 2
      if x + subview.dimensions(in: proposal).width / 2 > bounds.maxX {
        x = bounds.minX + subview.dimensions(in: proposal).width / 2
        y += height + verticalSpacing
      }
      subview.place(
        at: CGPoint(x: x, y: y),
        anchor: .center,
        proposal: ProposedViewSize(
          width: subview.dimensions(in: proposal).width,
          height: subview.dimensions(in: proposal).height
        )
      )
      x += subview.dimensions(in: proposal).width / 2 + horizontalSpacing
    }
  }
}
