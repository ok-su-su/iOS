//
//  View+Alert.swift
//  SSAlert
//
//  Created by MaraMincho on 4/14/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

public extension View {
  func customAlert(
    isPresented: Binding<Bool>
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      MessageAlert(.init(
        titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요",
        checkBoxMessage: .text("체크박스 메세지"),
        buttonMessage: .doubleButton(left: "닫기", right: "버튼명")
      ),
      isPresented: isPresented)
        .presentationBackground(.clear)
    }
    .transaction { transaction in
      if isPresented.wrappedValue {
        transaction.disablesAnimations = true
        transaction.animation = .linear(duration: 0.1)
      }
    }
  }
}
