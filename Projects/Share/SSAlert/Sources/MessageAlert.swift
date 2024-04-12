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
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text(titleText)
          .multilineTextAlignment(.center)
          .modifier(SSTextModifier(.title_xs))
          .frame(maxWidth: .infinity)

        Text(contentText)
          .multilineTextAlignment(.center)
          .modifier(SSTextModifier(.title_xxs))
          .frame(maxWidth: .infinity)
      }

      HStack(alignment: .center, spacing: 8) {
        Button(action: {}, label: {
          Text("닫기")
            .font(SSFont.title_l.font)

            .tint(Color.black)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        })
        .frame(maxWidth: .infinity)
        .background {
          Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

        Button(action: {}, label: {
          Text("닫기")
            .font(SSFont.title_l.font)
            .bold()
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        })
        .frame(maxWidth: .infinity)
        .background {
          Color(SSColor.orange60)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
      }
      .padding(0)
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding(24)
    .frame(width: 312)
    .background {
      Color.blue
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MessageAlert(titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요 텍스트 메세지를 입력하세요")
  }
}
