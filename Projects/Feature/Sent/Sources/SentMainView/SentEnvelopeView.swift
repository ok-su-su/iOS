//
//  SentEnvelopeView.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - EnvelopeView

struct EnvelopeView: View {
  @Bindable
  var store: StoreOf<Envelope>

  var body: some View {
    VStack {
      ZStack {
        ZStack {
          SSColor.gray10
          VStack(spacing: 0) {
            SSColor.red100
              .frame(maxWidth: .infinity, maxHeight: 40)

            CustomTriangle()
              .fill(SSColor.red100)
              .frame(maxWidth: .infinity, maxHeight: 24)
            Spacer()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }

      Text("asdf")
      Text("HelloWorld")
    }
    .background {
      SSImage.envelopeFill
    }
  }
}

// MARK: - CustomTriangle

struct CustomTriangle: Shape {
  var startValue: CGFloat = 9 / 36
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: .init(x: 0, y: 0))
    path.addLine(to: .init(x: 0, y: startValue))
    path.addLine(to: .init(x: rect.size.width / 2, y: rect.size.height))
    path.addLine(to: .init(x: rect.size.width, y: startValue))
    path.addLine(to: .init(x: rect.size.width, y: 0))
    path.closeSubpath()

    return path
  }
}
