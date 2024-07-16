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
import SSBottomSelectSheet
import SSCreateEnvelope
import SwiftUI

// MARK: - LedgerDetailMainView

struct LedgerDetailMainView: View {
  @Bindable var store: StoreOf<LedgerDetailMain>

  @ViewBuilder
  private func makeTopContentView() -> some View {
    let badgeText = "총 \(store.ledgerProperty.totalCounts)개"
    VStack(spacing: 16) {
      VStack(alignment: .leading, spacing: 8) {
        Text("전체 \(store.ledgerProperty.totalAmountText)")
          .modifier(SSTypoModifier(.title_m))
          .foregroundColor(SSColor.gray100)
          .frame(maxWidth: .infinity, alignment: .leading)

        SSBadge(property: .init(size: .small, badgeString: badgeText, badgeColor: .gray30))
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
  private func makeEnvelopesView() -> some View {
    ScrollView {
      LazyVStack(spacing: 8) {
        ForEach(store.envelopeItems) { property in
          EnvelopeViewForLedgerMain(property: property)
            .onTapGesture {
              store.sendViewAction(.tappedEnvelope(id: property.id))
            }
            .onAppear {
              store.sendViewAction(.appearedEnvelope(property))
            }
        }
      }
      .scrollTargetLayout()
    }
  }

  @ViewBuilder
  func makeFilterSection() -> some View {
    // MARK: - 필터 버튼

    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        SSButton(.init(
          size: .sh32,
          status: .active,
          style: .ghost,
          color: .black,
          leftIcon: .icon(SSImage.commonFilter),
          buttonText: store.sortProperty.selectedFilterDial?.description ?? ""
        )) {
          store.sendViewAction(.tappedSortButton)
        }

        // MARK: - 정렬 버튼

        // 정렬된 사람이 없을 때
        if !store.isFilteredItem {
          SSButton(Constants.filterButtonProperty) {
            store.send(.view(.tappedFilterButton))
          }
        } else {
          // 정렬된 사람이 있을 때
          Button {
            store.send(.view(.tappedFilterButton))
          } label: {
            SSImage.commonFilterWhite
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .frame(height: 32, alignment: .center)
              .background(SSColor.gray100)
              .cornerRadius(4)
          }

          // amount Range Button
          if let amountRangeBadgeText = store.filterProperty.amountFilterBadgeText {
            SSButton(
              .init(
                size: .sh32,
                status: .active,
                style: .filled,
                color: .black,
                rightIcon: .icon(SSImage.commonDeleteWhite),
                buttonText: amountRangeBadgeText
              )
            ) {
              store.sendViewAction(.tappedFilteredAmountButton)
            }
          }

          // 사람 버튼에 대한 표시
          let filtered = store.filterProperty.selectedItems
          ForEach(filtered) { property in
            SSButton(
              .init(
                size: .sh32,
                status: .active,
                style: .filled,
                color: .black,
                rightIcon: .icon(SSImage.commonDeleteWhite),
                buttonText: property.title
              )
            ) {
              store.sendViewAction(.tappedFilteredPersonButton(id: property.id))
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      // Top Section
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .padding(.bottom, 24)

        makeTopContentView()
          .padding(.horizontal, 16)
          .padding(.bottom, 16)
      }
      .background(SSColor.gray15)

      Spacer()
        .frame(height: 8)

      // BottomSection
      ScrollViewWithFilterItems(
        isLoading: store.isLoading,
        isRefresh: store.isRefresh
      ) {
        makeFilterSection()
          .padding(.bottom, 16)
      } content: {
        makeEnvelopesView()
      } refreshAction: {
        store.sendViewAction(.pullRefreshButton)
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
        .onAppear {
          store.sendViewAction(.isOnAppear(true))
        }
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
    .ssFloatingButton {
      store.sendViewAction(.tappedFloatingButton)
    }
    .fullScreenCover(isPresented: $store.presentCreateEnvelope.sending(\.scope.presentCreateEnvelope)) {
      CreateEnvelopeRouterBuilder(
        currentType: .received,
        initialCreateEnvelopeRequestBody: store.createEnvelopeProperty
      ) { data in
        store.sendViewAction(.dismissCreateEnvelope(data))
      }
    }
    .fullScreenCover(item: $store.scope(state: \.filter, action: \.scope.filter)) { store in
      LedgerDetailFilterView(store: store)
    }
    .modifier(SSSelectableBottomSheetModifier(store: $store.scope(state: \.sort, action: \.scope.sort)))
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
