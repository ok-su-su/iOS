//
//  TopContentWithProfileAndText.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - TopContentWithProfileAndText

struct TopContentWithProfileAndText: View {
  var property: TopContentWithProfileAndTextProperty
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .center, spacing: 8) {
        // Profile Image
        property
          .image
          .resizable()
          .frame(width: 20, height: 20)

        // Profile Name
        Text(property.name)
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundStyle(SSColor.gray100)
      }

      // Content Text
      Text(property.contentText)
        .modifier(SSTypoModifier(.text_xxs))
        .foregroundStyle(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
    }
    .frame(maxWidth: .infinity)
  }

  private enum Constants {
    static let defaultsImage: Image = SSImage.mypageSusu
  }
}

// MARK: - TopContentWithProfileAndTextProperty

struct TopContentWithProfileAndTextProperty {
  private let userImage: Image?
  private let userName: String?
  private let userText: String?

  var image: Image {
    if let userImage {
      return userImage
    }
    return SSImage.mypageSusu
  }

  var name: String {
    return userName ?? "익명 수수"
  }

  var contentText: String {
    return userText ?? ""
  }

  init(userImage: Image?, userName: String?, userText: String?) {
    self.userImage = userImage
    self.userName = userName
    self.userText = userText
  }
}
