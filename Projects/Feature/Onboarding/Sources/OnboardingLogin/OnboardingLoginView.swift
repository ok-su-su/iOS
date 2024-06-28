//
//  OnboardingLoginView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import AppleLogin
import AuthenticationServices
import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - OnboardingLoginView

struct OnboardingLoginView: View {
  // MARK: - Animation 활용하기 위한

  @State private var isVisible = false
  @State private var offsetY: CGFloat = 0

  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingLogin>

  @State private var endAngle: Angle = .init(degrees: 0)
  @State private var firstLineTitleText: String = ""
  @State private var secondLineTitleText: String = ""

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
        .frame(height: 40)

      makeChartDescriptionView()
      Spacer()
        .frame(height: 39)
      makeLoginButtonView()
      Spacer()
    }
  }

  @ViewBuilder
  private func makeChartDescriptionView() -> some View {
    VStack {
      // FirstLine
      HStack(spacing: 4) {
        Text(Constants.firstLineLeadingText)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(SSColor.gray90)

        // AnimationTextView

        Text(firstLineTitleText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.orange60)
          .frame(width: 65, height: 36)
          .padding(.vertical, 2)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 4))
          .onChange(of: store.helper.displayPercentageText) { _, newValue in
            withAnimation(.easeIn(duration: 1)) {
              firstLineTitleText = newValue
            }
          }

        Text(Constants.firstLineTrailingText)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(SSColor.gray90)
      }

      // SecondLine
      // Animation Text View
      HStack(spacing: 4) {
        Text(secondLineTitleText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.orange60)
          .frame(width: 82, height: 36)
          .padding(.vertical, 2)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 4))
          .onChange(of: store.helper.displayPriceText) { _, newValue in
            withAnimation(.easeIn(duration: 1)) {
              secondLineTitleText = newValue
            }
          }

        Text(Constants.secondLineText)
          .modifier(SSTypoModifier(.title_s))
          .foregroundStyle(SSColor.gray90)
      }
    }
  }

  @ViewBuilder
  private func makePieChartView() -> some View {
    ZStack {
      Circle()
        .frame(width: Metrics.circleWithAndHeight, height: Metrics.circleWithAndHeight)
        .foregroundStyle(SSColor.orange20)

      SectorShape(
        startAngle: endAngle,
        endAngle: .init(degrees: 0),
        clockwise: false
      )
      .stroke(SSColor.orange50, lineWidth: 8)
      .fill(SSColor.orange40)
      .frame(width: 200, height: 200)
    }
    .onAppear {
      endAngle = .init(degrees: store.helper.displaySectorShapeDegree)
    }
    .onChange(of: store.helper.displaySectorShapeDegree) { _, newValue in
      withAnimation(.easeInOut(duration: 1.2)) {
        endAngle = .init(degrees: newValue)
      }
    }
  }

  @ViewBuilder
  private func makeLoginButtonView() -> some View {
    VStack(spacing: 4) {
      // KAKAO Login Button

      makeLoginButtonViewByLoginType(.KAKAO) {
        store.send(.view(.tappedKakaoLoginButton))
      }
      .allowsHitTesting(false)

      ZStack {
        SignInWithAppleButton(
          .continue,
          onRequest: LoginWithApple.loginWithAppleOnRequest
        ) { result in
          LoginWithApple.loginWithAppleOnCompletion(result)
          switch result {
          case .success:
            store.sendViewAction(.successAppleLogin)
          case .failure:
            break
          }
        }
        // isOnApper되고 나서 로그인 버튼 뷰 게층 뒤쪽에 쌓임.
        // 코드를 이렇게 짠 이유는 Modifier가 생각처럼 잘 안먹었음.
        .opacity(store.isOnAppear ? 1 : .zero)
        .frame(maxWidth: .infinity, maxHeight: 56)

        makeLoginButtonViewByLoginType(.APPLE) {}
          .allowsHitTesting(false)
      }
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeLoginButtonViewByLoginType(_ loginType: LoginType, completion: @escaping () -> Void) -> some View {
    HStack(alignment: .center, spacing: 0) {
      loginType
        .logo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 32, height: 23)

      Spacer()

      Text(loginType.buttonTitle)
        .modifier(SSTypoModifier(.text_xs))
        .foregroundStyle(loginType.titleColor)

      Spacer()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .frame(maxWidth: .infinity, maxHeight: 56)
    .background(loginType.buttonBackgroundColor)
    .cornerRadius(4)
    .onTapGesture {
      completion()
    }
  }

  var body: some View {
    // for animation
    GeometryReader { geometry in
      ZStack {
        SSColor
          .gray15
          .ignoresSafeArea()

        if isVisible {
          VStack(spacing: 0) {
            makeContentView()
          }
          .offset(y: offsetY)
          .transition(.opacity.animation(.easeOut(duration: 1.2)))
          .animation(.easeIn(duration: 1.2), value: offsetY)
        }
      }

      .navigationBarBackButtonHidden()
      .onAppear {
        // generated by GPT
        // Calculate the initial offset as 1/10 of the screen height
        let screenHeight = geometry.size.height
        let initialOffset = screenHeight / 10

        // Set the initial offset
        offsetY = initialOffset

        withAnimation {
          isVisible = true
        }

        // Delay the animation by 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
          offsetY = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
          store.send(.view(.onAppear(true)))
        }
      }
    }
  }

  private enum Metrics {
    static let circleWithAndHeight: CGFloat = 200
  }

  private enum Constants {
    static let titleText: String = "받은 마음과 보낸 마음"
    static let titleDescriptionText: String = "잊지말고 수수에서 챙기세요"
    static let firstLineLeadingText: String = "수수 가입자"
    static let firstLineTrailingText: String = "는"
    static let secondLineText: String = "이 적당하다고 답했어요"
  }
}

// MARK: - SectorShape

struct SectorShape: Shape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool = false

  /// Generated By GPT
  var animatableData: AnimatablePair<Double, Double> {
    get { AnimatablePair(startAngle.radians, endAngle.radians) }
    set {
      startAngle = Angle(radians: newValue.first)
      endAngle = Angle(radians: newValue.second)
    }
  }

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

private extension LoginType {
  var logo: Image {
    switch self {
    case .KAKAO:
      return SSImage.signInKakaoLogo
    case .APPLE:
      return SSImage.signInAppleLogo
    case .GOOGLE:
      fatalError()
    }
  }

  var buttonTitle: String {
    switch self {
    case .KAKAO:
      "카카오로 계속하기"
    case .APPLE:
      "Apple로 계속하기"
    case .GOOGLE:
      fatalError()
    }
  }

  var titleColor: Color {
    switch self {
    case .KAKAO:
      SSColor.gray100.opacity(0.85)
    case .APPLE:
      SSColor.gray10
    case .GOOGLE:
      fatalError()
    }
  }

  var buttonBackgroundColor: Color {
    switch self {
    case .KAKAO:
      SSColor.kakaoLoginButtonBackgroundColor
    case .APPLE:
      SSColor.appleLoginButtonBackgroundColor
    case .GOOGLE:
      fatalError()
    }
  }
}
