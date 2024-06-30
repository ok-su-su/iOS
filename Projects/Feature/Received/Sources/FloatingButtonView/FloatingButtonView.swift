//
//  FloatingButtonView.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Designsystem
import SwiftUI

struct FloatingButtonView: View {
  // MARK: Content

  let completion: () -> Void
  init(completion: @escaping () -> Void) {
    self.completion = completion
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage.commonAdd
        .onTapGesture {
          completion()
        }
    }
    .padding(12)
    .frame(width: 48, height: 48, alignment: .center)
    .background(SSColor.gray100)
    .cornerRadius(100)
    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 8)
  }

  var body: some View {
    makeContentView()
  }
}
