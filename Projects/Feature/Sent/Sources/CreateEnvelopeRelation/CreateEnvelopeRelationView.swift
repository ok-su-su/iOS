//
//  CreateEnvelopeRelationView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeRelationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeRelation>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      Spacer()
        .frame(height: 34)
      
      // MARK: - TextFieldTitleView
      
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)
      
      Spacer()
        .frame(height: 34)
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
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

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let titleText: String = "누구에게 보냈나요?"
  }
}
