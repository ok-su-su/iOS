//
//  SSFilterWithDateView.swift
//  SSFilter
//
//  Created by MaraMincho on 10/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

struct SSFilterWithDateView: View {
  @Bindable
  var store: StoreOf<SSFilterWithDateReducer>

  init(store: StoreOf<SSFilterWithDateReducer>) {
    self.store = store
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
              Text(store.dateProperty.startDateText ?? store.dateProperty.defaultDateText)
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(store.dateProperty.startDateText == nil ? SSColor.gray40 : SSColor.gray100)
            }
            .onTapGesture {
              store.send(.view(.tappedLeftDateButton))
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
              Text(store.dateProperty.endDateText ?? store.dateProperty.defaultDateText)
                .modifier(SSTypoModifier(.title_xs))
                .foregroundColor(store.dateProperty.endDateText == nil ? SSColor.gray40 : SSColor.gray100)
            }
            .onTapGesture {
              store.send(.view(.tappedRightDateButton))
            }

          Text("까지")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundColor(SSColor.gray100)
        }
      }
    }
    .showDatePicker(store: $store.scope(state: \.datePicker, action: \.scope.datePicker))
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var body: some View {
    makeDateFilterContentView()
      .onAppear {
        store.send(.view(.onAppear(true)))
      }
  }
}
