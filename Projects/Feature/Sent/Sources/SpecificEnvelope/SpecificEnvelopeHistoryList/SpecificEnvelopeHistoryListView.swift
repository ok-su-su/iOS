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
      
      
      //MARK: TopView
      VStack(alignment: .leading, spacing: 8) {
        Text(Constants.titlePriceText)
          .modifier(SSTypoModifier(.title_m))
        
        SmallBadge(
          property:
              .init(
                size: .xSmall,
                badgeString: Constants.descriptionButtonText,
                badgeColor: .gray30)
        )
        
        Spacer()
          .frame(height: 24)
        
        
        
      }
    }
  }
  
  @ViewBuilder
  private func makeProgressBarView() -> some View {
    ZStack(alignment: .topLeading) {
      SSColor.orange20
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      SSColor.orange60
        .frame(maxWidth: store.progressValue, maxHeight: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, maxHeight: Metrics.progressHeightValue)
    .clipShape(RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous))
    .padding(.vertical, Metrics.progressBarVerticalSpacing)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
      }
      .padding(.horizontal, Metrics.horizontalSpacing)
    }

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
