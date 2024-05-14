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

// MARK: - SSModalShetType

enum SSModalShetType {
  case filter
  case sort
}

// MARK: - SortTypes

enum SortTypes: String, CaseIterable {
  case latest = "최신순"
  case oldest = "오래된순"
  case highestPrice = "금액 높은 순"
  case lowestPrice = "금액 낮은 순"
}

// MARK: - InventoryModalSheet

@Reducer
struct InventoryModalSheet {
  @ObservableState
  struct State {
    var filterItem: SortTypes.AllCases = []
    var selectedDate: Date = .now

    init(filterItem: SortTypes.AllCases, selectedDate: Date) {
      self.filterItem = filterItem
      self.selectedDate = selectedDate
    }
  }

  enum Action: Equatable {
    case reload
  }

  var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .reload:

        return .none
      }
    }
  }
}

// MARK: - InventoryModalSheetView

struct InventoryModalSheetView: View {
  @State private var selectedDate = Date.now
  let property: SSModalShetType

  init(property: SSModalShetType) {
    self.property = property
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    GeometryReader { geometry in
      VStack(alignment: .leading) {
        switch property {
        case .filter:
          DatePicker("", selection: $selectedDate, displayedComponents: [.date])
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            .datePickerStyle(.wheel)
            .colorMultiply(SSColor.gray100)
            .font(.custom(.title_xxs))
        default:
          ZStack {}
        }
      }
    }
  }

  var body: some View {
    makeContentView()
      .frame(maxWidth: .infinity)
  }
}

// MARK: - InventoryFilterView

struct InventoryFilterView: View {
  @Bindable var store: StoreOf<InventoryFilter>
  @State private var isPresent: Bool = true
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
      }.onTapGesture {}
        .padding(10)
        .overlay {
          RoundedRectangle(cornerRadius: 100)
            .inset(by: 0.5)
            .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
        }
      SSButton(.init(size: .sh48, status: .active, style: .filled, color: .black, buttonText: "필터 적용하기", frame: .init(maxWidth: .infinity))) {}
        .allowsHitTesting(false)
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
    }
  }

  @ViewBuilder
  private func makeSelectedFilterContentView() -> some View {
    HStack {
      HStack {
        Grid(alignment: .leading, horizontalSpacing: 8) {
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
        }
      }.padding(.leading, Spacing.leading)
    }
  }

  
  private func makeDateFilterContentView() -> some View {
    Group {
      if true {
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
                  Text(store.previousDate.toString())
                    .modifier(SSTypoModifier(.title_xs))
                    .foregroundColor(SSColor.gray40)
                }
                .onTapGesture {
                  store.send(.didShowFilterView)
                }

              Text("부터")
                .modifier(SSTypoModifier(.title_xxs))
                .foregroundColor(SSColor.gray100)

              Rectangle()
                .fill(SSColor.gray15)
                .frame(width: 118, height: 36)
                .overlay {
                  let _ = print(store.nextDate)
                  Text(store.nextDate.toString())
                    .modifier(SSTypoModifier(.title_xs))
                    .foregroundColor(SSColor.gray40)
                }
                .sheet(isPresented: $isPresent) {
                  InventoryModalSheetView(property: .filter)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }

              Text("까지")
                .modifier(SSTypoModifier(.title_xxs))
                .foregroundColor(SSColor.gray100)
            }.padding(.leading, Spacing.leading)
          }
        }
      } else {
        EmptyView()
      }
    }
    

  }

  var body: some View {
    makeHeaderContentView()
    makeFilterContentView()
      .onAppear {
        store.send(.reloadFilter)
      }
      .navigationBarBackButtonHidden()

    makeDateFilterContentView()
    makeSelectedFilterContentView()
    makeFilterConfirmContentView()
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
