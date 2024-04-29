//
//  SliderView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Designsystem
import Foundation
import SwiftUI

// MARK: - SliderView

struct SliderView: View {
  @ObservedObject var slider: CustomSlider

  var body: some View {
    RoundedRectangle(cornerRadius: slider.lineWidth)
      .fill(Color.gray.opacity(0.2))
      .frame(width: slider.width, height: slider.lineWidth)
      .overlay(
        ZStack {
          // Path between both handles
          SliderPathBetweenView(slider: slider)

          // Low Handle
          SliderHandleView(handle: slider.lowHandle)
            .highPriorityGesture(slider.lowHandle.sliderDragGesture)

          // High Handle
          SliderHandleView(handle: slider.highHandle)
            .highPriorityGesture(slider.highHandle.sliderDragGesture)
        }
      )
  }
}

// MARK: - SliderHandleView

struct SliderHandleView: View {
  @ObservedObject var handle: SliderHandle

  var body: some View {
    ZStack {
      Circle()
        .frame(width: handle.diameter, height: handle.diameter)
        .foregroundColor(.white)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 2)
        .scaleEffect(handle.onDrag ? 1.3 : 1)
        .contentShape(Rectangle())

      Circle()
        .frame(width: 8, height: 8)
        .foregroundColor(SSColor.orange60)
        .contentShape(Rectangle())
    }
    .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
  }
}

// MARK: - SliderPathBetweenView

struct SliderPathBetweenView: View {
  @ObservedObject var slider: CustomSlider

  var body: some View {
    Path { path in
      path.move(to: slider.lowHandle.currentLocation)
      path.addLine(to: slider.highHandle.currentLocation)
    }
    .stroke(SSColor.orange60, lineWidth: slider.lineWidth)
  }
}
