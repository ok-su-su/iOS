//
//  ScrollViewWithFilterItems.swift
//  Designsystem
//
//  Created by MaraMincho on 7/16/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import OSLog
import SwiftUI

// MARK: - ScrollOffsetPreferenceKey

import SwiftUI

// MARK: - ScrollOffsetPreferenceElement

struct ScrollOffsetPreferenceElement: Equatable {
  var topValue: CGFloat
  var bottomValue: CGFloat

  static func + (lhs: ScrollOffsetPreferenceElement, rhs: ScrollOffsetPreferenceElement) -> ScrollOffsetPreferenceElement {
    ScrollOffsetPreferenceElement(topValue: lhs.topValue + rhs.topValue, bottomValue: lhs.bottomValue + rhs.bottomValue)
  }

  static func += (lhs: inout ScrollOffsetPreferenceElement, rhs: ScrollOffsetPreferenceElement) {
    lhs = lhs + rhs
  }
}

// MARK: - ScrollOffsetPreferenceKey

struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: ScrollOffsetPreferenceElement = .init(topValue: 0, bottomValue: 0)

  static func reduce(value: inout ScrollOffsetPreferenceElement, nextValue: () -> ScrollOffsetPreferenceElement) {
    value += nextValue()
  }
}

// MARK: - ScrollBottomOffsetPreferenceKey

struct ScrollBottomOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}

// MARK: - ScrollViewWithFilterItems

public struct ScrollViewWithFilterItems<Header: View, Content: View>: View {
  @State private var showingHeader = true
  private var isLoading: Bool
  private var isRefresh: Bool
  @State private var scrollOffset: CGFloat = 0
  @State private var isTopContentDisplayed = true

  var header: Header
  var content: Content
  var refreshAction: () -> Void

  public init(
    isLoading: Bool,
    isRefresh: Bool,
    @ViewBuilder header: () -> Header,
    @ViewBuilder content: () -> Content,
    refreshAction: @escaping () -> Void
  ) {
    self.isLoading = isLoading
    self.isRefresh = isRefresh
    self.header = header()
    self.content = content()
    self.refreshAction = refreshAction
  }

  @ViewBuilder
  private func makeHeaderView() -> some View {
    if showingHeader {
      header
        .transition(
          .asymmetric(
            insertion: .push(from: .top),
            removal: .push(from: .bottom)
          )
        )
    }
  }

  @ViewBuilder
  private func makeBackgroundScrollOffsetObserver(_ outer: GeometryProxy) -> some View {
    GeometryReader { inner in
      Color
        .clear
        .preference(
          key: ScrollOffsetPreferenceKey.self,
          value: .init(
            topValue: inner.frame(in: .named("scroll")).minY,
            bottomValue: outer.size.height - inner.frame(in: .named("scroll")).maxY
          )
        )
    }
  }

  @ViewBuilder
  private func makeScrollContentView() -> some View {
    VStack(spacing: 0) {
      header
        .opacity(0)

      content
        .modifier(SSLoadingModifier(isLoading: isLoading))
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    GeometryReader { outer in
      ScrollView(.vertical) {
        ZStack {
          makeBackgroundScrollOffsetObserver(outer)

          makeScrollContentView()
        }
      }
      .coordinateSpace(name: "scroll")
    }
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
      let offsetChange = value.topValue - scrollOffset
      defer {
        scrollOffset = value.topValue
      }
      if value.bottomValue > -50 || value.topValue > -50 {
        return
      }
      if (-1 ... 1) ~= offsetChange {
        return
      } else if offsetChange >= 0 {
        showingHeader = true

      } else {
        showingHeader = false
      }
    }
  }

  public var body: some View {
    ZStack(alignment: .top) {
      VStack(spacing: 0) {
        makeContentView()
      }
      makeHeaderView()
    }
    .refreshable {
      DispatchQueue.main.async {
        refreshAction()
        showingHeader = true
      }
      do {
        try await waitForRefreshToEnd()
      } catch {
        os_log(.fault, "waitForRefreshToEnd가 비정상적으로 종료되었습니다.")
      }
      showingHeader = true
    }
    .scrollIndicators(.hidden)
    .animation(.default, value: showingHeader)
    .allowsHitTesting(!isRefresh)
    .clipped()
  }

  private func waitForRefreshToEnd() async throws {
    while isRefresh {
      try await Task.sleep(nanoseconds: 1_000_000_000) // 10 milliseconds
    }
  }
}
