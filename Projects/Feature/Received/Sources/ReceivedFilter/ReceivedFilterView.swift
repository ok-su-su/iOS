//
//  ReceivedFilterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SSFilter
import SSFirebase
import SSLayout
import SwiftUI

// MARK: - ReceivedFilterView

struct ReceivedFilterView: View {
  @Bindable var store: StoreOf<ReceivedFilter>

  init(store: StoreOf<ReceivedFilter>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .padding(.bottom, 24)
        SSFilterView(store: store.scope(state: \.filterState, action: \.scope.filterAction), topSectionTitle: "경조사카테고리", textFieldPrompt: "")
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }
    }
    .onAppear {
      store.sendViewAction(.onAppear(true))
    }
    .navigationBarBackButtonHidden()
    .ssAnalyticsScreen(moduleName: .Received(.filter))
  }

  private enum Constants {
    nonisolated(unsafe) static let butonProperty = SSButtonPropertyState(size: .xsh28, status: .active, style: .filled, color: .orange, buttonText: "   ")
  }

  private enum Spacing {
    static let top: CGFloat = 16
    static let leading: CGFloat = 16
  }
}

public extension DateFormatter {
  static func withFormat(_ format: String) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = TimeZone.autoupdatingCurrent
    formatter.locale = Locale.autoupdatingCurrent
    return formatter
  }
}

extension Date {
  func toString(with format: String = "YYYY.MM.dd") -> String {
    let dateFormatter = DateFormatter.withFormat(format)
    return dateFormatter.string(from: self)
  }
}
