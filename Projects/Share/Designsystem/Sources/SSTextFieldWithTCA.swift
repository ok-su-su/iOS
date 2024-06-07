//
//  SSTextFieldWithTCA.swift
//  Designsystem
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import ComposableArchitecture



public struct SSTextFieldReducerProperty: Equatable {
  var text: String
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
    }else if status == .active && text.isEmpty {
      return .gray
    }
    return .black
  }
  
  public init(text: String, placeHolderText: SSTextPlaceholderText, status: TextFieldStatus, errorMessage: String) {
    self.text = text
    self.placeHolderText = placeHolderText
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
}

@Reducer
public struct SSTextFieldReducer {
  @ObservableState
  public struct State: Equatable {
    @Shared var property: SSTextFieldReducerProperty
    public init(property: Shared<SSTextFieldReducerProperty>) {
      self._property = property
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
  init (store: StoreOf<SSTextFieldReducer>) {
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
  private func makeLine() -> some View{
    switch store.property.lineStatus {
      case .red: SSColor.red60
      case .black: SSColor.gray100
      case .gray: SSColor.gray50
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
