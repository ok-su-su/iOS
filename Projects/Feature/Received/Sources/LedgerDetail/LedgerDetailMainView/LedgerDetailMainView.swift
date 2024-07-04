//
//  LedgerDetailMainView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSAlert
import SSCreateEnvelope
import SwiftUI

// MARK: - LedgerDetailMainView

struct LedgerDetailMainView: View {
  @Bindable var store: StoreOf<LedgerDetailMain>

  @ViewBuilder
  private func makeTopContentView() -> some View {
    VStack(spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        Text("전체 \(store.ledgerProperty.totalAmountText)")
          .modifier(SSTypoModifier(.title_m))
          .foregroundColor(SSColor.gray100)
          .frame(maxWidth: .infinity, alignment: .leading)

        Rectangle()
          .fill(SSColor.gray30)
          .frame(width: 61, height: 24)
          .cornerRadius(4)
          .overlay {
            Text("총 \(store.envelopeItems.count)개")
              .modifier(SSTypoModifier(.title_xxxs))
              .foregroundColor(SSColor.gray70)
          }
      }

      VStack(spacing: 4) {
        makeTopSectionDescriptionView(leadingTitle: "경조사 카테고리", trailingTitle: store.ledgerProperty.category)

        makeTopSectionDescriptionView(leadingTitle: "경조사 명", trailingTitle: store.ledgerProperty.title)

        makeTopSectionDescriptionView(leadingTitle: "경조사 기간", trailingTitle: store.ledgerProperty.dateText)
      }
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeTopSectionDescriptionView(leadingTitle: String, trailingTitle: String) -> some View {
    HStack {
      Text(leadingTitle)
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundColor(SSColor.gray60)

      Spacer()

      Text(trailingTitle)
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundColor(SSColor.gray80)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }

  @ViewBuilder
  private func makeLineView() -> some View {
    Rectangle()
      .fill(SSColor.gray25)
      .frame(maxWidth: .infinity, maxHeight: 8)
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    HStack(spacing: 8) {
      SSButton(Constants.filterButtonProperty) {
        store.send(.view(.tappedFilterButton))
      }
      SSButton(Constants.sortButtonProperty) {
        store.send(.view(.tappedSortButton))
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  @ViewBuilder
  private func makeEnvelopesView() -> some View {
    ScrollView {
      LazyVStack(spacing: 8) {
        ForEach(store.envelopeItems) { property in
          EnvelopeViewForLedgerMain(property: property)
        }
      }
      .scrollTargetLayout()
    }
  }

  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      // Top Section
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .padding(.bottom, 24)

        makeTopContentView()
          .padding(.horizontal, 16)
          .padding(.bottom, 8)
      }
      .background(SSColor.gray15)

      Spacer()
        .frame(height: 8)

      // BottomSection
      VStack(spacing: 0) {
        makeFilterContentView()
          .padding(.bottom, 16)

        makeEnvelopesView()
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .background(SSColor.gray15)
    }
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      SSColor
        .gray25
        .ignoresSafeArea()

      makeContentView()
        .modifier(SSLoadingModifier(isLoading: store.isLoading))
        .onAppear {
          store.sendViewAction(.isOnAppear(true))
        }

      FloatingButtonView {
        store.sendViewAction(.tappedFloatingButton)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
    }
    .sSAlert(
      isPresented: $store.showMessageAlert.sending(\.view.showAlert),
      messageAlertProperty: .init(
        titleText: " 장부를 삭제할까요?",
        contentText: "삭제한 장부와 봉투는 다시 복구할 수 없어요",
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(left: "취소", right: "삭제"),
        didTapCompletionButton: { _ in
          store.sendViewAction(.tappedDeleteLedgerButton)
        }
      )
    )
    .fullScreenCover(isPresented: $store.presentCreateEnvelope.sending(\.scope.presentCreateEnvelope)) {
      CreateEnvelopeRouterBuilder(currentType: .received(ledgerId: store.ledgerID)) { data in
        store.sendViewAction(.dismissCreateEnvelope(data))
      }
    }
    .navigationBarBackButtonHidden()
  }

  private enum Constants {
    static let filterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )

    static let sortButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "정렬"
    )
  }
}
