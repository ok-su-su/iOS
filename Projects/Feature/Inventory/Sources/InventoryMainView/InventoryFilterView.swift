//
//  InventoryFilterView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

import ComposableArchitecture

// MARK: - InventoryFilterView

struct InventoryFilterView: View {
  @Bindable var store: StoreOf<InventoryFilter>

  init(store: StoreOf<InventoryFilter>) {
    self.store = store
  }

  private func makeHeaderContentView() -> some View {
    ZStack(alignment: .top) {
      HeaderView(store: store.scope(state: \.header, action: \.header))
      Spacer()
        .frame(height: 24)
    }
  }

  @ViewBuilder
  private func makeFilterConfirmContentView() -> some View {
    HStack {
      ZStack {
        SSImage.commonRefresh
      }.onTapGesture {
        store.send(.reset)
      }
      .padding(10)
      .overlay {
        RoundedRectangle(cornerRadius: 100)
          .inset(by: 0.5)
          .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
      }

      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {
        store.send(.didTapConfirmButton)
      }
    }.padding([.leading, .trailing], 16)
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
    GeometryReader { _ in
      VStack(alignment: .leading) {
        Text("경조사 카테고리")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.gray100)
          .padding(.top, 24)
          .padding(.leading, Spacing.leading)

        HStack {
          Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
              ForEach(0 ..< store.inventoryFilter.count, id: \.self) { index in
                SSButtonWithState(store.ssButtonProperties[index, default: Constants.butonProperty]) {
                  store.send(.didTapFilterButton(index))
                }
              }
            }
          }
        }.padding(.leading, Spacing.leading)
      }
    }.frame(height: 72)
  }

  @ViewBuilder
  private func makeSelectedFilterContentView() -> some View {
    Grid(horizontalSpacing: 8) {
      GridRow {
        ForEach(0 ..< store.selectedFilter.count, id: \.self) { index in
          SSButton(
            .init(
              size: .xsh28,
              status: .active,
              style: .filled,
              color: .orange,
              rightIcon: .icon(SSImage.commonDeleteWhite),
              buttonText: store.selectedFilter[index].type
            )
          ) {
            store.send(.didTapFilterButton(index))
          }
        }
      }
    }.padding(.leading, Spacing.leading)
  }

  @ViewBuilder
  private func makeDateFilterContentView() -> some View {
    GeometryReader { _ in
      VStack(alignment: .leading) {
        Text("날짜")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.gray100)
          .padding(.leading, Spacing.leading)
        HStack {
          Rectangle()
            .fill(SSColor.gray15)
            .frame(width: 118, height: 36)
            .overlay {
              Text(store.startDate?.toString() ?? "")
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(store.startDate == .now ? SSColor.gray100 : SSColor.gray40)
            }
            .onTapGesture {
              store.send(.didShowStartDateFilterView)
            }

          Text("부터")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundColor(SSColor.gray100)

          Rectangle()
            .fill(SSColor.gray15)
            .frame(width: 118, height: 36)
            .overlay {
              Text(store.endDate?.toString() ?? "")
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(SSColor.gray40)
            }
            .onTapGesture {
              store.send(.didShowEndDateFilterView)
            }

          Text("까지")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundColor(SSColor.gray100)
        }
        .padding(.leading, Spacing.leading)
      }
    }
  }

  var body: some View {
    makeHeaderContentView()
    VStack {
      makeFilterContentView()
      Spacer()
        .frame(height: 48)
      makeDateFilterContentView()
      Spacer()
      VStack(alignment: .leading, spacing: 8) {
        makeSelectedFilterContentView()
        makeFilterConfirmContentView()
      }
    }
    .onAppear {
      store.send(.reloadFilter)
    }
    .navigationBarBackButtonHidden()
    .sheet(item: $store.scope(state: \.sheet, action: \.sheet)) { store in
      InventoryModalSheetView(store: store)
        .presentationDetents([.height(370), .medium])
        .presentationDragIndicator(.automatic)
    }
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
