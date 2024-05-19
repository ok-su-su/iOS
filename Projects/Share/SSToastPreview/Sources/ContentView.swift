//
//  ContentView.swift
//  SSToastPreview
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Designsystem
import SSToast

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
          store.send(.toast(.onAppear(true)))
        } label: {
          Text("SSToastPreview if tap show Toast")
        }
        
        Button {
          store.send(.toast(.onAppear(false)))
        } label: {
          Text("SSToastPreview if tap show Toast")
        }

        Spacer()
      }
    }
    .modifier(SSToastModifier(toastStore: store.scope(state: \.toast, action: \.toast)))
  }
}

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
    
    Reduce { state, action in
      switch action {
      case .toast:
        return .none
      }
    }
  }
  
}
