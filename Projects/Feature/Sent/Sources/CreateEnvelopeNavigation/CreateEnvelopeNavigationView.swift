// 
//  CreateEnvelopeNavigationView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

public struct CreateEnvelopeNavigationView: View {
  
  // MARK: Reducer
  @Bindable
  public var store: StoreOf<CreateEnvelopeNavigation>

  // MARK: Content
  @ViewBuilder
  private func makeContentView() -> some View {

  }

  public var body: some View {
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
  
  // MARK: Init
  public init(store: StoreOf<CreateEnvelopeNavigation>) {
    self.store = store
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
