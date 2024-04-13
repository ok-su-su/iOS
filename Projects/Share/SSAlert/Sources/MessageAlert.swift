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

  public init(titleText: String, contentText: String, checkBoxMessage: CheckBoxMessage, buttonMessage: ButtonMessage) {
    self.titleText = titleText
    self.contentText = contentText
    self.checkBoxMessage = checkBoxMessage
    self.buttonMessage = buttonMessage
  }

  public enum CheckBoxMessage: Equatable {
    case none
    case text(String)
  }

  public enum ButtonMessage: Equatable {
    case singleButton(String)
    case doubleButton(left: String, right: String)
  }
}

// MARK: - CheckBoxView

private struct CheckBoxView: View {
  @State var isTapped: Bool = false
  var checkBoxImage: Image { isTapped ? Image(uiImage: SSImage.commonArrow) : Image(uiImage: SSImage.commonfilter) }
  var textColor: Color { isTapped ? SSColor.gray100 : SSColor.gray40 }
  var checkBoxString: String
  var body: some View {
    HStack(alignment: .top) {
      checkBoxImage
        .frame(width: 24, height: 24)
      Text(checkBoxString)
        .modifier(SSTextModifier(.title_xxxs))
        .bold()
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
  public init(_ messageAlertProperty: MessageAlertProperty) {
    self.messageAlertProperty = messageAlertProperty
  }

  @ViewBuilder
  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 24) {
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
        if case let .text(text) = messageAlertProperty.checkBoxMessage {
          CheckBoxView(checkBoxString: text)
        }

        switch messageAlertProperty.buttonMessage {
        case let .singleButton(buttonText):
          SSButton(
            .init(
              size: .sh40,
              status: .active,
              style: .filled,
              color: .orange,
              buttonText: buttonText,
              frame: .init(maxWidth: .infinity)
            ),
            onTap: {}
          )
        case let .doubleButton(left, right):
          HStack(spacing: 8) {
            SSButton(
              .init(
                size: .sh40,
                status: .active,
                style: .ghost,
                color: .black,
                buttonText: left,
                frame: .init(maxWidth: .infinity)
              ),
              onTap: {}
            )
            .frame(maxWidth: .infinity)

            SSButton(
              .init(
                size: .sh40,
                status: .active,
                style: .filled,
                color: .orange,
                buttonText: right,
                frame: .init(maxWidth: .infinity)
              ),
              onTap: {}
            )
            .frame(maxWidth: .infinity)
          }
        }
      }
      .padding(24)
    }
    .background { SSColor.gray10 }
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .frame(width: 312)
  }
}

#Preview {
  VStack {
    MessageAlert(.init(
      titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요",
      checkBoxMessage: .text("체크박스 메세지"),
      buttonMessage: .doubleButton(left: "닫기", right: "버튼명")
    ))

    MessageAlert(.init(
      titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요",
      checkBoxMessage: .text("체크박스 메세지"),
      buttonMessage: .singleButton("확인했어요")
    ))
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background {
    Color.blue
  }
}
