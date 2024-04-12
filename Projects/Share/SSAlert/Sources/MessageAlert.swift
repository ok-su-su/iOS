//
//  MessageAlert.swift
//  SSAlert
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - MessageAlert

public struct MessageAlertProperty {
  let titleText: String
  let contentText: String
  let checkBoxMessage: CheckBoxMessage
  let buttonMessage: ButtonMessage
  public enum CheckBoxMessage {
    case none
    case text(String)
  }
  public enum ButtonMessage {
    case singleButton(String)
    case doubleButton(left: String, right: String)
  }
}

public struct MessageAlert: View {
  let messageAlertProperty: MessageAlertProperty
  init(_ messageAlertProperty: MessageAlertProperty) {
    self.messageAlertProperty = messageAlertProperty
  }

  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 8) {
          Text(messageAlertProperty.titleText)
            .multilineTextAlignment(.center)
            .modifier(SSTextModifier(.title_xs, isBold: true))
            .tint(SSColor.gray100)
            .frame(maxWidth: .infinity)

          Text(messageAlertProperty.contentText)
            .multilineTextAlignment(.center)
            .modifier(SSTextModifier(.title_xxs))
            .frame(maxWidth: .infinity)
        }

        HStack(alignment: .center, spacing: 8) {
          Button(action: {}, label: {
            Text("버튼 명")
              .modifier(SSTextModifier(.title_xxs, isBold: true))
              .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
              .tint(SSColor.gray100)
          })
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background {
            Color.white
          }
          .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

          Button(action: {}, label: {
            Text("닫기")
              .modifier(SSTextModifier(.title_xxs, isBold: true))
              .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
              .tint(SSColor.gray10)
          })
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background {
            SSColor.orange60
          }
          .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
      }
      .padding(24)
    }
    .background { SSColor.gray10 }
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .frame(width: 312)
  }
}
