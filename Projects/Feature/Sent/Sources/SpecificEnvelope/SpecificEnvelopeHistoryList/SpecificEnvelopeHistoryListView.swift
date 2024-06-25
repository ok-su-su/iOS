//
//  SpecificEnvelopeHistoryListView.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSAlert
import SwiftUI

struct SpecificEnvelopeHistoryListView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<SpecificEnvelopeHistoryList>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 24)

      // MARK: TopView, 상단 Progress 및 	title을 나타냅니다.

      VStack(alignment: .leading, spacing: 8) {
        Text(store.envelopeProperty.totalPriceText)
          .modifier(SSTypoModifier(.title_m))

        SmallBadge(
          property:
          .init(
            size: .xSmall,
            badgeString: sentSubReceivedTitleText,
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
      ForEach(store.envelopeContents) { property in
        makeDetailContentView(property)
      }
      Spacer()
        .frame(height: 16)
    }
  }

  @ViewBuilder
  private func makeDetailContentView(_ property: EnvelopeContent) -> some View {
    let textColor = property.envelopeType == .sent ? SSColor.gray90 : SSColor.gray40
    HStack {
      HStack(spacing: 12) {
        property.envelopeType == .sent ? SSImage.envelopeBackArrow : SSImage.envelopeForwardArrow
        SmallBadge(
          property: .init(
            size: .small,
            badgeString: property.eventName,
            badgeColor: property.envelopeType == .sent ? .gray90 : .gray40
          )
        )

        Text(property.dateText)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(textColor)
      }
      Spacer()
      Text(property.priceText)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(textColor)
    }
    .padding(.vertical, 12)
    .onTapGesture {
      store.send(.view(.tappedSpecificEnvelope(property)))
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
      .padding(.horizontal, Metrics.horizontalSpacing)
    }
    .sSAlert(
      isPresented: $store.isDeleteAlertPresent,
      messageAlertProperty: .init(
        titleText: Constants.alertTitleText,
        contentText: Constants.alertDescriptionText,
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(
          left: Constants.alertLeftButtonText,
          right: Constants.alertRightButtonText
        ),
        didTapCompletionButton: { _ in
          store.send(.view(.tappedAlertConfirmButton))
        }
      )
    )
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
    static let alertTitleText = "모든 봉투를 삭제할까요?"
    static let alertDescriptionText = "삭제한 봉투는 다시 복구할 수 없어요"
    static let alertLeftButtonText = "취소"
    static let alertRightButtonText = "삭제"
  }

  var sentSubReceivedTitleText: String {
    CustomNumberFormatter.formattedByThreeZero(store.envelopeProperty.sentSubReceivedValue, subFixString: "원") ?? ""
  }
}
