//
//  ScrollViewWithFilterItems.swift
//  Designsystem
//
//  Created by MaraMincho on 7/16/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import OSLog
import SwiftUI

public struct ScrollViewWithFilterItems<Header: View, Content: View>: View {
  @State private var showingHeader = true
  private var isLoading: Bool
  private var isRefresh: Bool

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

  public var body: some View {
    VStack(spacing: 0) {
      if showingHeader {
        header
          .transition(
            .asymmetric(
              insertion: .push(from: .top),
              removal: .push(from: .bottom)
            )
          )
      }

      GeometryReader { outer in
        let outerHeight = outer.size.height
        ScrollView(.vertical) {
          content
            .background {
              GeometryReader { proxy in
                let contentHeight = proxy.size.height
                let minY = max(
                  min(0, proxy.frame(in: .named("ScrollView")).minY),
                  outerHeight - contentHeight
                )

                Color
                  .clear
                  .onChange(of: minY) { oldVal, newVal in
                    if (showingHeader && newVal < oldVal) || !showingHeader && newVal > oldVal {
                      showingHeader = newVal > oldVal
                    }
                  }
              }
            }
            .modifier(SSLoadingModifier(isLoading: isLoading))
        }
        .coordinateSpace(name: "ScrollView")
      }
      // Prevent scrolling into the safe area
      .padding(.top, 1)
    }
    .refreshable {
      showingHeader = true
      DispatchQueue.main.async {
        refreshAction()
      }
      do {
        try await waitForRefreshToEnd()
      } catch {
        os_log(.fault, "waitForRefrshToEnd가 비정상적으로 종료되었습니다.")
      }
      showingHeader = true
    }
    .animation(.default, value: showingHeader)
    .allowsHitTesting(!isRefresh)
    .onChange(of: isLoading) { _, _ in
      showingHeader = true
    }
    .clipped()
  }

  private func waitForRefreshToEnd() async throws {
    while isRefresh {
      try await Task.sleep(nanoseconds: 1_000_000_000) // 10 milliseconds
    }
  }
}
