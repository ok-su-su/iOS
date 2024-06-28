// 
//  SSSelectableItemsView.swift
//  SSSelectableItems
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct SSSelectableItemsView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<SSSelectableItemsReducerReducer>
  
  //MARK: Init
  init(store: StoreOf<SSSelectableItemsReducerReducer>) {
    self.store = store
    self.store.send(.view(.isInited(true)))
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
