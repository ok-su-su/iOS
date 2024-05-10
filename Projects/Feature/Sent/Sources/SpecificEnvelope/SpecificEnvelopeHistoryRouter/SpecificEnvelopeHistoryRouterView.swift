// 
//  SpecificEnvelopeHistoryRouterView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct SpecificEnvelopeHistoryRouterView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryRouter>

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {

  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
    }
    .onAppear{
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
