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
import SSLayout
import SwiftUI

// MARK: - ReceivedFilterView

struct ReceivedFilterView: View {
  @Bindable var store: StoreOf<ReceivedFilter>

  init(store: StoreOf<ReceivedFilter>) {
    self.store = store
  }

  @ViewBuilder
  private func makeFilterConfirmContentView() -> some View {
    HStack {
      ZStack {
        SSImage.commonRefresh
      }.onTapGesture {
        store.sendViewAction(.tappedResetButton)
      }
      .padding(10)
      .overlay {
        RoundedRectangle(cornerRadius: 100)
          .inset(by: 0.5)
          .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
      }

      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
        store.sendViewAction(.tappedConfirmButton)
      }
    }.padding([.leading, .trailing], 16)
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    VStack(alignment: .leading) {
      Text("경조사 카테고리")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .padding(.leading, Spacing.leading)

      WrappingHStack(horizontalSpacing: 8) {
        ForEach(store.property.selectableLedgers) { property in
          let isSelected = store.property.isSelectedItems(id: property.id)
          SSButtonWithState(
            .init(
              size: .xsh28,
              status: isSelected ? .active : .inactive,
              style: .lined,
              color: .black,
              leftIcon: .none,
              rightIcon: .none,
              buttonText: property.title
            )) {
              store.sendViewAction(.tappedItem(property))
            }
        }
      }
    }
  }

  @ViewBuilder
  private func makeSelectedFilterContentView() -> some View {
    WrappingHStack(horizontalSpacing: 8) {
      if let selectedString = store.property.selectedFilterDateTextString {
        SSButtonWithState(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            leftIcon: .none,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: selectedString
          )) {
            store.sendViewAction(.tappedSelectedFilterDateItem)
          }
      }
      ForEach(store.property.selectedLedgers) { property in
        SSButtonWithState(
          .init(
            size: .xsh28,
            status: .active,
            style: .filled,
            color: .orange,
            leftIcon: .none,
            rightIcon: .icon(SSImage.commonDeleteWhite),
            buttonText: property.title
          )) {
            store.sendViewAction(.tappedItem(property))
          }
      }
    }
  }

  @ViewBuilder
  private func makeDateFilterContentView() -> some View {
    VStack(alignment: .leading) {
      Text("날짜")
        .modifier(SSTypoModifier(.title_xs))
        .foregroundColor(SSColor.gray100)
        .frame(alignment: .leading)

      HStack(spacing: 16) {

        HStack(spacing: 4) {
          SSColor.gray15
            .frame(width: 118, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay {
              Text(store.startDateText ?? store.defaultDateText)
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(store.startDateText == nil ? SSColor.gray40 : SSColor.gray100)
            }
            .onTapGesture {
              store.sendViewAction(.tappedLeftDateButton)
            }

          Text("부터")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundColor(SSColor.gray100)
        }

        HStack(spacing: 4) {
          SSColor.gray15
            .frame(width: 118, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay {
              Text(store.endDateText ?? store.defaultDateText)
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(store.endDateText == nil ? SSColor.gray40 : SSColor.gray100)
            }
            .onTapGesture {
              store.sendViewAction(.tappedRightDateButton)
            }

          Text("까지")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundColor(SSColor.gray100)
        } 
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .padding(.bottom, 24)

        VStack(spacing: 0) {
          makeFilterContentView()
            .padding(.horizontal, 16)
            .padding(.bottom, 48)

          makeDateFilterContentView()
            .padding(.horizontal, 16)
          Spacer()
          VStack(alignment: .leading, spacing: 8) {
            makeSelectedFilterContentView()
              .padding(.horizontal, 16)
            makeFilterConfirmContentView()
          }
        }
        .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }
    }
    .onAppear {
      store.sendViewAction(.onAppear(true))
    }
    .navigationBarBackButtonHidden()
    .modifier(SSDateBottomSheetModifier(store: $store.scope(state: \.datePicker, action: \.scope.datePicker)))
  }

  private enum Constants {
    static let butonProperty: SSButtonPropertyState = .init(size: .xsh28, status: .active, style: .filled, color: .orange, buttonText: "   ")
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
