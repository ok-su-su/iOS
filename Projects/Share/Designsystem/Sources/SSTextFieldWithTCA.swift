//
//  SSTextFieldWithTCA.swift
//  Designsystem
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import OSLog
import SwiftUI

// MARK: - SSTextFieldReducerProperty

public struct SSTextFieldReducerProperty: Equatable {
  var text: String
  var maximumTextLength: Int
  var regexPattern: String
  var placeHolderText: SSTextPlaceholderText
  var isFocus: Bool = false
  var status: TextFieldStatus
  var errorMessage: String

  var textLength: Int {
    return text.count
  }

  var lineStatus: LineStatus {
    if status == .error {
      return .red
    } else if status == .active && text.isEmpty {
      return .gray
    }
    return .black
  }

  /// SSTextFieldReducerProperty의 Reducer을 생성하기 위해 필요한 Property입니다.
  /// - Parameters:
  ///   - text: 초기 입력되는 TextField의 Text입니다. 이 변수 통해서, Text가 저장됩니다.
  ///   - maximumTextLength: textField의 최대 입력할 수 있는 글자수입니다.
  ///   - regexPattern: 정규식을 통해서 에러를 검출하게 되는데, 정규식의 String형태를 입력받습니다.
  ///   - placeHolderText: PlaceHoloderText의 Tpye을 입력받습니다.
  ///   - isFocus: Focuse되는지에 대한 변수 입니다.
  ///   - status: 현재 Status에 대해서 입력받습니다.
  ///   - errorMessage: Error Status일 때 표시될 에러 메시지 입니다.
  init(
    text: String,
    maximumTextLength: Int,
    regexPattern: String,
    placeHolderText: SSTextPlaceholderText,
    isFocus: Bool = false,
    status: TextFieldStatus = .active,
    errorMessage: String
  ) {
    self.text = text
    self.maximumTextLength = maximumTextLength
    self.regexPattern = regexPattern
    self.placeHolderText = placeHolderText
    self.isFocus = isFocus
    self.status = status
    self.errorMessage = errorMessage
  }

  public enum TextFieldStatus {
    case active
    case error
  }

  public enum LineStatus {
    case gray
    case black
    case red
  }

  public mutating func changeErrorMessage(text: String) {
    errorMessage = text
  }

  private func isValidation(text: String) -> Bool {
    do {
      let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
      let range = NSRange(location: 0, length: text.utf16.count)
      return regex.firstMatch(in: text, options: [], range: range) != nil
    } catch {
      os_log("입력한 정규식이 잘못 되었습니다. \n \(regexPattern)")
      return false
    }
  }
}

// MARK: - SSTextFieldReducer

@Reducer
public struct SSTextFieldReducer {
  @ObservableState
  public struct State: Equatable {
    @Shared var property: SSTextFieldReducerProperty
    public init(property: Shared<SSTextFieldReducerProperty>) {
      _property = property
    }
  }

  public enum Action: Equatable {
    case changeTextField(String)
    case tappedCloseButton
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .changeTextField(text):
        state.property.text = text
        return .none

      case .tappedCloseButton:
        return .send(.changeTextField(""))
      }
    }
  }
}

// MARK: - SSTextFieldView

public struct SSTextFieldView: View {
  @FocusState public var isFocus: Bool

  @Bindable
  var store: StoreOf<SSTextFieldReducer>
  public init(store: StoreOf<SSTextFieldReducer>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 8) {
        TextField(
          "",
          text: $store.property.text.sending(\.changeTextField),
          prompt: store.property.placeHolderText.placeholder
        )
        .background(.clear)
        .foregroundColor(.gray100)
        .modifier(SSTypoModifier(.title_l))
        .keyboardType(store.property.placeHolderText.keyboardType)
        .frame(maxWidth: .infinity)
        .focused($isFocus)
        .onChange(of: store.property.isFocus) { _, newValue in
          isFocus = newValue
        }

        if store.property.text.isEmpty {
          SSImage
            .signupClose
            .onTapGesture {
              store.send(.tappedCloseButton)
            }
            .padding(.horizontal, 12)
        }

        Text("\(store.property.textLength)/20")
          .foregroundStyle(store.property.status == .active ? SSColor.gray30 : .red60)
      }
      .padding(8)
      .frame(maxWidth: .infinity)

      // Line
      makeLine()
        .frame(width: .infinity, height: 1)

      Spacer()
        .frame(height: 8)
      // Error Message

      if store.property.status == .error {
        Text(store.property.errorMessage)
          .foregroundStyle(SSColor.red60)
      }
    }
  }

  @ViewBuilder
  private func makeLine() -> some View {
    switch store.property.lineStatus {
    case .red: SSColor.red60
    case .black: SSColor.gray100
    case .gray: SSColor.gray50
    }
  }
}
