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

public struct MessageAlert: View {
  var titleText: String
  var contentText: String
  public init(titleText: String, contentText: String) {
    self.titleText = titleText
    self.contentText = contentText
  }

  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 8) {
          Text(titleText)
            .multilineTextAlignment(.center)
            .modifier(SSTextModifier(.title_xs, isBold: true))
            .tint(SSColor.gray100)
            .frame(maxWidth: .infinity)

          Text(contentText)
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

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MessageAlert(titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요")
  }
}
