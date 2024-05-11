//
//  CreateEnvelopePriceView.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SwiftUI

// MARK: - CreateEnvelopePriceView

struct CreateEnvelopePriceView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopePrice>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      SSTextField(isDisplay: true, text: $store.textFieldText, property: .amount, isHighlight: $store.textFieldIsHighlight)
        .onChange(of: store.textFieldText) { oldValue, newValue in
          if oldValue == newValue {
            return
          }
          store.send(.view(.changeText(newValue)))
        }

      Spacer()
        .frame(height: 32)

      // MARK: - Price Guid View

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(store.formattedGuidPrices, id: \.self) { item in
          SSButton(
            .init(size: .sh32, status: .active, style: .filled, color: .orange, buttonText: "\(item)원")) {
              store.send(.view(.tappedGuidValue(item)))
            }
        }
      }

      Spacer()
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
  }

  @ViewBuilder
  private func makeNextButton() -> some View {
    CreateEnvelopeBottomOfNextButtonView(
      store: store.scope(state: \.nextButton, action: \.scope.nextButton)
    )
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(alignment: .leading) {
        makeContentView()
        makeNextButton()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let titleText: String = "얼마를 보냈나요?"
  }
}

// MARK: - WrappingHStack

private struct WrappingHStack: Layout {
  /// inspired by: https://stackoverflow.com/a/75672314
  private var horizontalSpacing: CGFloat
  private var verticalSpacing: CGFloat
  public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat? = nil) {
    self.horizontalSpacing = horizontalSpacing
    self.verticalSpacing = verticalSpacing ?? horizontalSpacing
  }

  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
    guard !subviews.isEmpty else { return .zero }

    let height = subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0

    var rowWidths = [CGFloat]()
    var currentRowWidth: CGFloat = 0
    subviews.forEach { subview in
      if currentRowWidth + horizontalSpacing + subview.sizeThatFits(proposal).width >= proposal.width ?? 0 {
        rowWidths.append(currentRowWidth)
        currentRowWidth = subview.sizeThatFits(proposal).width
      } else {
        currentRowWidth += horizontalSpacing + subview.sizeThatFits(proposal).width
      }
    }
    rowWidths.append(currentRowWidth)

    let rowCount = CGFloat(rowWidths.count)
    return CGSize(width: max(rowWidths.max() ?? 0, proposal.width ?? 0), height: rowCount * height + (rowCount - 1) * verticalSpacing)
  }

  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
    let height = subviews.map { $0.dimensions(in: proposal).height }.max() ?? 0
    guard !subviews.isEmpty else { return }
    var x = bounds.minX
    var y = height / 2 + bounds.minY
    subviews.forEach { subview in
      x += subview.dimensions(in: proposal).width / 2
      if x + subview.dimensions(in: proposal).width / 2 > bounds.maxX {
        x = bounds.minX + subview.dimensions(in: proposal).width / 2
        y += height + verticalSpacing
      }
      subview.place(
        at: CGPoint(x: x, y: y),
        anchor: .center,
        proposal: ProposedViewSize(
          width: subview.dimensions(in: proposal).width,
          height: subview.dimensions(in: proposal).height
        )
      )
      x += subview.dimensions(in: proposal).width / 2 + horizontalSpacing
    }
  }
}
