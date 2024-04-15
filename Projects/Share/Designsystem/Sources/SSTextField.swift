//
//  SSTextField.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/15/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: SSTextPlaceholderText

public enum SSTextPlaceholderText {
  case signUp
  case account
  case amount
  case gift
  case contact
  case contents
  case holiday
  
  public var placeholder: Text {
    switch self {
    case .signUp:
      Text("김수수")
    case .account:
      Text("이름을 입력해주세요")
    case .amount:
      Text("금액을 입력해주세요")
    case .gift:
      Text("무엇을 선물했나요")
    case .contact:
      Text("01012345678")
    case .contents:
      Text("입력해주세요")
    case .holiday:
      Text("경조사명을 입력해주세요")
    }
  }
  
  public var keyboardType: UIKeyboardType {
    switch self {
    case .signUp, .account:
      return .namePhonePad
    case .amount, .contact:
      return .numberPad
    case .contents, .holiday, .gift:
      return .default
    }
  }

}

// MARK: SSTextField

public struct SSTextField: View {
  
  @State public var text: String = ""
  @FocusState public var isFocus: Bool
  
  public var isDisplay: Bool
  public var property: SSTextPlaceholderText
  
  public init(isDisplay: Bool, property: SSTextPlaceholderText) {
    self.isDisplay = isDisplay
    self.property = property
  }
  
  public var body: some View {
    TextField("", text: $text, prompt: property.placeholder)
      .modifier(SSTextFieldModifier())
      .modifier(UnderLineModifier(isLine: true, lienColor: .black, linePadding: 35))
      .keyboardType(property.keyboardType)
      .focused($isFocus)
      .onSubmit {
        isFocus = false
      }
  }
}

// MARK: SSTextFieldModifier

public struct SSTextFieldModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .background(.clear)
      .foregroundColor(SSColor.gray100)
      .frame(height: 44)
      .modifier(SSTextModifier(.title_xl, isBold: true))
  }
}

// MARK: UnderLineModifier

public struct UnderLineModifier: ViewModifier {
  public var lienColor: Color
  public var linePadding: CGFloat
  public var isLine: Bool
  
  public init(isLine: Bool, lienColor: Color, linePadding: CGFloat) {
    self.lienColor = lienColor
    self.linePadding = linePadding
    self.isLine = isLine
  }
  
  @ViewBuilder
  public func body(content: Content) -> some View {
    if isLine {
      content.overlay {
        Rectangle()
          .fill(lienColor)
          .frame(height: 1)
          .padding(.top, linePadding)
      }
    }
  }
}

