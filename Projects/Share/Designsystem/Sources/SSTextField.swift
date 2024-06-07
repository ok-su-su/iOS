//
//  SSTextField.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/15/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Combine
import SwiftUI

// MARK: - SSTextPlaceholderText

public enum SSTextPlaceholderText {
  case signUp
  case account
  case amount
  case gift
  case contact
  case contents
  case holiday

  public var placeHolderTextString: String {
    switch self {
    case .signUp:
      "김수수"
    case .account:
      "이름을 입력해주세요"
    case .amount:
      "금액을 입력해주세요"
    case .gift:
      "무엇을 선물했나요"
    case .contact:
      "01012345678"
    case .contents:
      "입력해주세요"
    case .holiday:
      "경조사명을 입력해주세요"
    }
  }

  public var placeholder: Text {
    Text(placeHolderTextString)
  }

  public var keyboardType: UIKeyboardType {
    switch self {
    case .account,
         .signUp:
      return .namePhonePad
    case .amount,
         .contact:
      return .numberPad
    case .contents,
         .gift,
         .holiday:
      return .default
    }
  }
}

// MARK: - SSTextField

public struct SSTextField: View {
  @Binding private var text: String
  @Binding private var isHighlight: Bool
  @FocusState private var isFocus: Bool

  public var isDisplay: Bool
  public var property: SSTextPlaceholderText

  public init(isDisplay: Bool, text: Binding<String>, property: SSTextPlaceholderText, isHighlight: Binding<Bool>) {
    self.isDisplay = isDisplay
    self.property = property
    _text = text
    _isHighlight = isHighlight
  }

  public var body: some View {
    TextField("", text: $text, prompt: property.placeholder)
      .modifier(SSTextFieldModifier())
      .keyboardType(property.keyboardType)
      .modifier(UnderLineModifier(textFieldText: $text, isLine: isDisplay, linePadding: 43, isShow: isHighlight))
      .modifier(PlaceHolderModifier(isHighlight: isHighlight))
      .frame(height: 44)
      .fixedSize(horizontal: false, vertical: false)
      .focused($isFocus)
      .onChange(of: text) {
        if isValidation(text: text) {
          isHighlight = true
        } else {
          isHighlight = false
        }
      }
      .onSubmit {
        isFocus = false
      }
  }

  private func isValidation(text: String) -> Bool {
    let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]*$"
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
      let range = NSRange(location: 0, length: text.utf16.count)

      if regex.firstMatch(in: text, options: [], range: range) != nil && text.count <= 10 {
        return true
      }
    }

    return false
  }
}

// MARK: - PlaceHolderModifier

public struct PlaceHolderModifier: ViewModifier {
  private let isHighlight: Bool

  init(isHighlight: Bool) {
    self.isHighlight = isHighlight
  }

  public func body(content: Content) -> some View {
    VStack {
      content
      if !isHighlight {
        SSText(text: "한글과 영문 10자이내로 작성해주세요", designSystemFont: .title_s)
          .foregroundColor(.red60)
          .padding(.top, -8)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

// MARK: - SSTextFieldModifier

public struct SSTextFieldModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .background(.clear)
      .foregroundColor(.gray100)
      .modifier(SSTextModifier(.title_xl, isBold: true))
  }
}

// MARK: - UnderLineModifier

public struct UnderLineModifier: ViewModifier {
  @Binding private var textFieldText: String
  private var linePadding: CGFloat
  private var isLine: Bool
  private var isShow: Bool

  public init(textFieldText: Binding<String>, isLine: Bool, linePadding: CGFloat, isShow: Bool) {
    self.linePadding = linePadding
    self.isLine = isLine
    _textFieldText = textFieldText
    self.isShow = isShow
  }

  @ViewBuilder
  public func body(content: Content) -> some View {
    if isLine {
      VStack {
        HStack {
          content
          Image(uiImage: .signupClose)
            .opacity(textFieldText == "" ? 0 : 1)
            .onTapGesture { textFieldText = "" }
          Text("\(textFieldText.count)/10")
            .foregroundStyle(isShow ? .gray30 : .red60)
            .modifier(SSTextModifier(.title_m, isBold: true))
            .padding(.trailing, 8)
        }
      }.background {
        Rectangle()
          .fill(isShow ? .gray100 : .red60)
          .frame(height: 1)
          .padding(.top, linePadding)
      }
    } else {
      content
    }
  }
}
