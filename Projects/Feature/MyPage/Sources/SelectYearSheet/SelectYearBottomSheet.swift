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
    var listItems: SelectYearListProperty = .init()

    var originalYear: Date?
    var originalYearString: String?

    init(originalYear: Date?) {
      guard let originalYear else {
        return
      }
      self.originalYear = originalYear
      originalYearString = SelectYearItemDateFormatter.yearStringFrom(date: originalYear)
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
      default:
        return .none
      }
    }
  }
}
