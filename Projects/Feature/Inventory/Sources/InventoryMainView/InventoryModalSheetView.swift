//
//  InventoryModalSheetView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - InventoryModalSheetView

struct InventoryModalSheetView: View {
  @Bindable var store: StoreOf<InventoryModalSheet>

  init(store: StoreOf<InventoryModalSheet>) {
    self.store = store
  }

  @ViewBuilder
  private func makeFilterContentView() -> some View {
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
  private func makeContentView() -> some View {
    GeometryReader { geometry in
      VStack(alignment: .leading) {
        DatePicker("", selection: $store.initialStartDate.sending(\.didSelectedStartDate), in: store.initialStartDate ... store.initialEndDate, displayedComponents: [.date])
          .clipped()
          .frame(maxWidth: .infinity)
          .datePickerStyle(.wheel)
          .labelsHidden()
          .environment(\.locale, Locale(identifier: "ko_kr"))
          .padding()
          .colorMultiply(SSColor.gray100)
          .font(.custom(.title_xxs))

      }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
    }.edgesIgnoringSafeArea(.all)
  }

  var body: some View {
    VStack {
      makeContentView()
      makeFilterContentView()
    }
  }
}
