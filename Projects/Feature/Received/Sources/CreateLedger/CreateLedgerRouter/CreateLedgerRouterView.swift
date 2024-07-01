// 
//  CreateLedgerRouterView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct CreateLedgerRouterView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<CreateLedgerRouter>
  
  //MARK: Init
  init(store: StoreOf<CreateLedgerRouter>) {
    self.store = store
  }

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear{
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
