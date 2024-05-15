//
//  SelectYearBottomSheet.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct SelectYearBottomSheet {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var listItems: SelectYearListProperty = .init()

    var originalYear: Date?
    var originalYearString: String?
    @Shared var selectedYear: Date?

    init(originalYear: Date?, selectedYear: Shared<Date?>) {
      self.originalYear = originalYear
      _selectedYear = selectedYear
    }
  }

  enum Action: Equatable {
    case tappedYear(String)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case let .tappedYear(title):
        return .none
      }
    }
  }
}
