//
//  SpecificEnvelopeHistoryDetailView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SpecificEnvelopeHistoryDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryDetail>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      HeaderView(store: store.scope(state: \.header, action: \.scope.header))

      Spacer()
        .frame(height: 24)

      VStack(spacing: 16) {
        Text(store.envelopeDetailProperty.priceText)
          .modifier(SSTypoModifier(.title_xxl))
          .foregroundStyle(SSColor.gray100)

        VStack(spacing: 0) {
          let listViewContent = store.envelopeDetailProperty.makeListContent
          ForEach(0 ..< listViewContent.count, id: \.self) { ind in
            let (title, description) = listViewContent[ind]
            makeListView(title: title, description: description)
          }
        }
      }
    }
  }

  @ViewBuilder
  private func makeListView(title: String, description _: String) -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .frame(width: 72)

      Text(title)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray100)
        .frame(maxWidth: .infinity)
    }
    .padding(.vertical, Metrics.listContentVerticalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      makeContentView()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let listContentVerticalSpacing: CGFloat = 16
  }

  private enum Constants {}
}
