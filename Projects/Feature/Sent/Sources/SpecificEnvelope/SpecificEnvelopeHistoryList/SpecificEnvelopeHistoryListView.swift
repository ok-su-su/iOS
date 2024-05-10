//
//  SpecificEnvelopeHistoryListView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct SpecificEnvelopeHistoryListView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryList>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      HeaderView(store: store.scope(state: \.header, action: \.scope.header))
      Spacer()
        .frame(height: 24)

      // MARK: TopView

      VStack(alignment: .leading, spacing: 8) {
        Text(Constants.titlePriceText)
          .modifier(SSTypoModifier(.title_m))

        SmallBadge(
          property:
          .init(
            size: .xSmall,
            badgeString: Constants.descriptionButtonText,
            badgeColor: .gray30
          )
        )

        // MARK: ProgressView

        EnvelopePriceProgressView(store: store.scope(state: \.envelopePriceProgress, action: \.scope.envelopePriceProgress))
          .padding(.vertical, 24)

        Spacer()
          .frame(maxWidth: .infinity, maxHeight: 8)
          .foregroundStyle(SSColor.gray20)

        Spacer()
          .frame(height: 16)
        ScrollView {
          makeEnvelopeDetails()
        }
      }
    }
  }

  @ViewBuilder
  private func makeEnvelopeDetails() -> some View {
    LazyVStack {
      ForEach(store.envelopeHistoryProperty.envelopeContents) { property in
        makeDetailContentView(property)
      }
      Spacer()
        .frame(height: 16)
    }
  }

  @ViewBuilder
  private func makeDetailContentView(_ property: EnvelopeContent) -> some View {
    HStack {
      HStack(spacing: 12) {
        SSImage.envelopeBackArrow
        SmallBadge(
          property: .init(
            size: .small,
            badgeString: property.eventName,
            badgeColor: property.envelopeType == .sent ? .gray90 : .gray40
          )
        )

        Text("23.07.18") // TODO: 수정
          .modifier(SSTypoModifier(.title_xxs))
      }
      Spacer()
      Text(property.priceText)
        .modifier(SSTypoModifier(.title_xs))
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
      .padding(.horizontal, Metrics.horizontalSpacing)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
    static let progressHeightValue: CGFloat = 4
    static let progressCornerRadius: CGFloat = 8
    static let progressBarVerticalSpacing: CGFloat = 4
  }

  private enum Constants {
    static let titlePriceText: String = "전체 100,000원"
    static let descriptionButtonText: String = "-40,000원"
  }
}