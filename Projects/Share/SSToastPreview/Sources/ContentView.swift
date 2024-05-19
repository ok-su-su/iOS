//
//  ContentView.swift
//  SSToastPreview
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSToast
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
  var store: StoreOf<ContentReducer>
  var body: some View {
    ZStack {
      Color.white
      VStack {
        Text("ToastView Test")
          .modifier(SSTypoModifier(.title_xxl))
          .padding()

        Button {
          store.send(.toast(.showToastMessage(Constants.shortToastMessage)), animation: .default)
        } label: {
          Text("SSToastPreview if tap show Toast")
        }

        Button {
          store.send(.toast(.showToastMessage(Constants.longToastMessage)), animation: .default)
        } label: {
          Text("Multiline SSToastPreview if tap show Toast")
        }

        Button {
          store.send(.toast(.finishToast))
        } label: {
          Text("SSToastPreview if tap close Toast")
        }

        Spacer()
      }
    }
    .modifier(SSToastModifier(toastStore: store.scope(state: \.toast, action: \.toast)))
  }

  private enum Constants {
    static let shortToastMessage = "수수의 토스트"
    static let longToastMessage = "수수의 토스트 수수의 \n토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 "
  }
}

// MARK: - ContentReducer

@Reducer
struct ContentReducer {
  struct State: Equatable {
    var toast: SSToastReducer.State = .init(.init(toastMessage: "TestToast", trailingType: .none, duration: 3))
  }

  enum Action: Equatable {
    case toast(SSToastReducer.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.toast, action: \.toast) {
      SSToastReducer()
    }

    Reduce { _, action in
      switch action {
      case .toast:
        return .none
      }
    }
  }
}
