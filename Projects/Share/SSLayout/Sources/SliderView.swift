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

public struct SliderView: View {
  @ObservedObject var slider: CustomSlider
  let numberOfIntervals: Int = 100
  var sliderHandlerBorderSize: CGFloat = 8

  public init(slider: CustomSlider) {
    self.slider = slider
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 4)
      .fill(SSColor.orange20)
      .frame(maxWidth: .infinity, maxHeight: slider.lineWidth)
      .overlay(
        GeometryReader { proxy in
          let width = proxy.size.width
          let midHeight = proxy.size.height / 2
          ZStack {
            // Path between both handles
            Path { path in
              path.move(to: .init(x: slider.lowHandle.currentPercentage.wrappedValue * width, y: midHeight))
              path.addLine(to: .init(x: slider.highHandle.currentPercentage.wrappedValue * width, y: midHeight))
            }
            .stroke(SSColor.orange60, lineWidth: slider.lineWidth)

            // Low Handle
            SliderHandleView(handle: slider.lowHandle)
              .position(
                x: sliderHandlerBorderSize + slider.lowHandle.currentPercentage.wrappedValue * width,
                y: midHeight
              )
              .highPriorityGesture(
                DragGesture().onChanged { value in
                  let currentLocation = value.location
                  let currentPercentage = currentLocation.x / width
                  let percentage = min(max(0, currentPercentage), slider.highHandle.currentPercentage.wrappedValue)
                  slider.lowHandle.updateCurrentPercentage(percentage)
                }
              )

            SliderHandleView(handle: slider.highHandle)
              .position(
                x: slider.highHandle.currentPercentage.wrappedValue * width - sliderHandlerBorderSize,
                y: midHeight
              )
              .highPriorityGesture(
                DragGesture().onChanged { value in
                  let currentLocation = value.location
                  let currentPercentage = currentLocation.x / width
                  let percentage = max(min(1, currentPercentage), slider.lowHandle.currentPercentage.wrappedValue)
                  slider.highHandle.updateCurrentPercentage(percentage)
                }
              )
          }
        }
      )
      .frame(maxWidth: .infinity, minHeight: 24)
  }
}

// MARK: - SliderHandleView

struct SliderHandleView: View {
  @ObservedObject var handle: SliderHandle

  var body: some View {
    ZStack {
      Circle()
        .frame(width: 24, height: 24)
        .foregroundColor(.white)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 4, y: 2)
        .scaleEffect(handle.onDrag ? 1.3 : 1)
        .contentShape(Rectangle())

      Circle()
        .frame(width: 8, height: 8)
        .foregroundColor(SSColor.orange60)
        .contentShape(Rectangle())
    }
  }
}
