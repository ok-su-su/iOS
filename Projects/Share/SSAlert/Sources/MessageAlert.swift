//
//  MessageAlert.swift
//  SSAlert
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - MessageAlertProperty

public struct MessageAlertProperty {
  let titleText: String
  let contentText: String
  let checkBoxMessage: CheckBoxMessage
  let buttonMessage: ButtonMessage
  let animationDuration: TimeInterval
  let didTapCompletionButton: (Bool) -> Void

  /// Alert에 표시할 정보들을 모아놓은 구조체 입니다.
  /// - Parameters:
  ///   - titleText: Alert에 Title입니다.
  ///   - contentText: Alert에 Description입니다.
  ///   - checkBoxMessage: Alert에 CheckBox에 표시될 메시지 타입을 고릅니다.
  ///    .text 일 경우 wildCard에 checkBox에 표시될 메시지를 입력받습니다.
  ///   - buttonMessage: ButtonMessage 타입을 선택합니다.
  ///   double버튼일 경우 leading tarinig의 Text를 입력받습니다.
  ///   - animationDuration: 얼럿이 나타날 떄 에니메이션의 시간을 입력받습니다.
  ///   - didTapCompletionButton: 확인 버튼이 눌렸을 때 실행되는 Callbcak입니다.
  ///   체크박스 탭 유무에 따라서 false true로 입력받습니다. 만약 checkbox를 사용하지 않는다면 false를 인자로 전달합니다.
  public init(
    titleText: String,
    contentText: String,
    checkBoxMessage: CheckBoxMessage,
    buttonMessage: ButtonMessage,
    animationDuration: TimeInterval = 0.3,
    didTapCompletionButton: @escaping (Bool) -> Void
  ) {
    self.titleText = titleText
    self.contentText = contentText
    self.checkBoxMessage = checkBoxMessage
    self.buttonMessage = buttonMessage
    self.animationDuration = animationDuration
    self.didTapCompletionButton = didTapCompletionButton
  }

  public enum CheckBoxMessage: Equatable {
    case none
    case text(String)
  }

  public enum ButtonMessage {
    case singleButton(String)
    case doubleButton(left: String, right: String)
  }
}

// MARK: - CheckBoxView

private struct CheckBoxView: View {
  @Binding var isTapped: Bool
  var checkBoxImage: Image { isTapped ? SSImage.commonCheckBox : SSImage.commonUnCheckBox }
  var textColor: Color { isTapped ? SSColor.gray100 : SSColor.gray40 }
  var checkBoxString: String
  var body: some View {
    HStack(alignment: .center) {
      checkBoxImage
        .frame(width: 24, height: 24)
      Text(checkBoxString)
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundStyle(textColor)
    }
    .onTapGesture {
      isTapped.toggle()
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - MessageAlert

public struct MessageAlert: View {
  let messageAlertProperty: MessageAlertProperty
  @Binding private var isPresented: Bool
  @State private var isAnimating = false
  @State private var checkedCheckBox = false
  @State private var opacity = 0.16
  public init(_ messageAlertProperty: MessageAlertProperty, isPresented: Binding<Bool>) {
    self.messageAlertProperty = messageAlertProperty
    _isPresented = isPresented
  }

  func dismiss() {
    opacity = 0
    isAnimating = false
    isPresented = false
  }

  func show() {
    withAnimation(.easeInOut(duration: messageAlertProperty.animationDuration)) {
      isAnimating = true
    }
  }

  @ViewBuilder
  func titleView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      let titleText = messageAlertProperty.titleText
      let contentText = messageAlertProperty.contentText
      if !titleText.isEmpty {
        Text(titleText)
          .foregroundStyle(SSColor.gray100)
          .multilineTextAlignment(.center)
          .modifier(SSTypoModifier(.title_xs))
          .bold()
          .tint(SSColor.gray100)
          .frame(maxWidth: .infinity)
      }

      if !contentText.isEmpty {
        Text(contentText)
          .foregroundStyle(SSColor.gray80)
          .multilineTextAlignment(.center)
          .modifier(SSTypoModifier(.text_xxs))
          .frame(maxWidth: .infinity)
      }
    }
  }

  @ViewBuilder
  func singleButtonView(_ buttonText: String) -> some View {
    SSButton(
      .init(
        size: .sh40,
        status: .active,
        style: .filled,
        color: .orange,
        buttonText: buttonText,
        frame: .init(maxWidth: .infinity)
      ),
      onTap: {
        dismiss()
        messageAlertProperty.didTapCompletionButton(checkedCheckBox)
      }
    )
  }

  @ViewBuilder
  func doubleButtonView(_ leftButtonText: String, _ rightButtonText: String) -> some View {
    HStack(spacing: 8) {
      Button {
        dismiss()
      } label: {
        Text(leftButtonText)
          .applySSFont(.title_xxs)
          .foregroundStyle(SSColor.gray100)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .frame(maxWidth: .infinity, maxHeight: 40)

      Button {
        messageAlertProperty.didTapCompletionButton(checkedCheckBox)
        dismiss()
      } label: {
        Text(rightButtonText)
          .applySSFont(.title_xxs)
          .foregroundStyle(SSColor.gray10)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(SSColor.orange60)
      }
      .frame(maxWidth: .infinity, maxHeight: 40)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  @ViewBuilder
  public var body: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()
        .opacity(opacity)
        .zIndex(0)

      if isAnimating {
        VStack {
          VStack(alignment: .leading, spacing: 24) {
            titleView()

            if case let .text(text) = messageAlertProperty.checkBoxMessage {
              CheckBoxView(isTapped: $checkedCheckBox, checkBoxString: text)
            }

            switch messageAlertProperty.buttonMessage {
            case let .singleButton(buttonText):
              singleButtonView(buttonText)
            case let .doubleButton(leftButtonText, rightButtonText):
              doubleButtonView(leftButtonText, rightButtonText)
            }
          }
          .padding(24)
        }
        .background { SSColor.gray10 }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .frame(width: 312)
        .zIndex(1)
      }
    }
    .onAppear {
      show()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
