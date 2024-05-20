//
//  SpecificEnvelopeHistoryDetailView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSAlert
import SwiftUI

struct SpecificEnvelopeHistoryDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryDetail>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 24)

      VStack(alignment: .leading, spacing: 16) {
        Text(store.envelopeDetailProperty.priceText)
          .modifier(SSTypoModifier(.title_xxl))
          .foregroundStyle(SSColor.gray100)

        ScrollView {
          LazyVStack(spacing: 0) {
            let listViewContent = store.envelopeDetailProperty.makeListContent
            ForEach(0 ..< listViewContent.count, id: \.self) { ind in
              let (title, description) = listViewContent[ind]
              makeListView(title: title, description: description)
            }
          }
        }
        .frame(maxHeight: .infinity)
      }
    }
  }

  @ViewBuilder
  private func makeListView(title: String, description: String) -> some View {
    HStack(alignment: .center, spacing: 16) {
      Text(title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .frame(width: 72, alignment: .leading)
        .multilineTextAlignment(.leading)

      Text(description)
        .modifier(SSTypoModifier(.title_s))
        .foregroundStyle(SSColor.gray100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
    }
    .padding(.vertical, Metrics.listContentVerticalSpacing)
  }

  var body: some View {
    let alertProperty = store.alertProperty
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.horizontal, Metrics.horizontalSpacing)
      }
    }
    .navigationBarBackButtonHidden()
    .sSAlert(
      isPresented: $store.isDeleteAlertPresent,
      messageAlertProperty: .init(
        titleText: alertProperty.title,
        contentText: alertProperty.description,
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(left: alertProperty.cancelButtonText, right: alertProperty.confirmButtonText),
        didTapCompletionButton: {
          store.send(.view(.tappedAlertConfirmButton))
        }
      )
    )
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let listContentVerticalSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {}
}
