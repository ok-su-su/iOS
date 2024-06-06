//
//  OnboardingLoginView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - OnboardingLoginView

struct OnboardingLoginView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingLogin>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 48)

      VStack(spacing: 4) {
        Text(Constants.titleText)
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100)

        Text(Constants.titleDescriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray50)
      }

      Spacer()
        .frame(height: 32)

      makePieChartView()
      Spacer()
    }
  }

  @ViewBuilder
  private func makePieChartView() -> some View {
    ZStack {
      Circle()
        .frame(width: Metrics.circleWithAndHeight, height: Metrics.circleWithAndHeight)
        .foregroundStyle(SSColor.orange20)

      SectorShape(startAngle: .init(degrees: 0), endAngle: .init(degrees: 270), clockwise: false)
        .stroke(SSColor.orange50, lineWidth: 8)
        .fill(SSColor.orange40)
        .frame(width: 200, height: 200)
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let circleWithAndHeight: CGFloat = 200
  }

  private enum Constants {
    static let titleText: String = "받은 마음과 보낸 마음"
    static let titleDescriptionText: String = "잊지말고 수수에서 챙기세요"
  }
}

// MARK: - PieChartView

struct PieChartView: Shape {
  private let startPoint = Angle(degrees: -90) // Start at the top
  let contentSize: CGSize
  let radian: Double // This should be in radians

  func path(in rect: CGRect) -> Path {
    Path { path in
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let radius = min(contentSize.width, contentSize.height) / 2
      let startAngle = startPoint
      let endAngle = startPoint + Angle(radians: radian)

      path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//      path.move(to: center)
//      path.move(to: .init(x: rect.midX, y: 0))
      path.closeSubpath()
    }
  }
}

// MARK: - SectorShape

struct SectorShape: Shape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool = false

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2

    path.move(to: center)
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    path.closeSubpath()

    return path
  }
}
