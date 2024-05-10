//
//  CreateEnvelopeAdditionalIsVisitedEventView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeAdditionalIsVisitedEventView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeAdditionalIsVisitedEvent>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(spacing: 4) {
      // TODO: change Property
//      Text("김철수님에게")
//        .modifier(SSTypoModifier(.title_m))
//        .foregroundStyle(SSColor.gray60)
//
//      Text(Constants.nameDescriptionText)
//        .modifier(SSTypoModifier(.title_m))
//        .foregroundStyle(SSColor.gray100)
    }
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
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
