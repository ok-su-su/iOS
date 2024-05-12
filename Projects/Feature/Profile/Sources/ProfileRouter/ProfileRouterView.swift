// 
//  ProfileRouterView.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct ProfileRouterView: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<ProfileRouter>

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
