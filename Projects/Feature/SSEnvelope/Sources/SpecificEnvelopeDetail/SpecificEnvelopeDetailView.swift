//
//  SpecificEnvelopeDetailView.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSAlert
import SwiftUI
import SSFirebase

public struct SpecificEnvelopeDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeDetailReducer>

  public init(store: StoreOf<SpecificEnvelopeDetailReducer>) {
    self.store = store
  }

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

        ScrollView(showsIndicators: false) {
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

  public var body: some View {
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
        didTapCompletionButton: { _ in
          store.send(.view(.tappedAlertConfirmButton))
        }
      )
    )
    .modifier(SSLoadingModifier(isLoading: store.isLoading))
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let listContentVerticalSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {}

  var alertProperty: (title: String, description: String, cancelButtonText: String, confirmButtonText: String) {
    return ("봉투를 삭제할까요?", "삭제한 봉투는 다시 복구할 수 없어요", "취소", "삭제")
  }
}
