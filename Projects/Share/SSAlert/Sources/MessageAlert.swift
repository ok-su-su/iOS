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
  let didTapCompletionButton: () -> Void

  public init(
    titleText: String,
    contentText: String,
    checkBoxMessage: CheckBoxMessage,
    buttonMessage: ButtonMessage,
    animationDuration: TimeInterval = 0.3,
    didTapCompletionButton: @escaping () -> Void
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
  @State var isTapped: Bool = false
  var checkBoxImage: Image { isTapped ? Image(uiImage: SSImage.commonCheckBox) : Image(uiImage: SSImage.commonUnCheckBox) }
  var textColor: Color { isTapped ? SSColor.gray100 : SSColor.gray40 }
  var checkBoxString: String
  var body: some View {
    HStack(alignment: .top) {
      checkBoxImage
        .frame(width: 24, height: 24)
      Text(checkBoxString)
        .modifier(SSTextModifier(.title_xxxs, isBold: true))
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
      Text(messageAlertProperty.titleText)
        .multilineTextAlignment(.center)
        .modifier(SSTextModifier(.title_xs, isBold: true))
        .bold()
        .tint(SSColor.gray100)
        .frame(maxWidth: .infinity)

      Text(messageAlertProperty.contentText)
        .multilineTextAlignment(.center)
        .modifier(SSTextModifier(.title_xxs))
        .frame(maxWidth: .infinity)
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
        messageAlertProperty.didTapCompletionButton()
      }
    )
  }

  @ViewBuilder
  func doubleButtonView(_ leftButtonText: String, _ rightButtonText: String) -> some View {
    HStack(spacing: 8) {
      SSButton(
        .init(
          size: .sh40,
          status: .active,
          style: .ghost,
          color: .black,
          buttonText: leftButtonText,
          frame: .init(maxWidth: .infinity)
        ),
        onTap: {
          dismiss()
        }
      )
      .frame(maxWidth: .infinity)

      SSButton(
        .init(
          size: .sh40,
          status: .active,
          style: .filled,
          color: .orange,
          buttonText: rightButtonText,
          frame: .init(maxWidth: .infinity)
        ),
        onTap: {
          dismiss()
          messageAlertProperty.didTapCompletionButton()
        }
      )
      .frame(maxWidth: .infinity)
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
              CheckBoxView(checkBoxString: text)
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
