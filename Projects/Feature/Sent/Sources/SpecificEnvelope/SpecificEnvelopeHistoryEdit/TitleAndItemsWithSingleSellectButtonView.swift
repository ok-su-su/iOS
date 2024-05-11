// 
//  TitleAndItemsWithSingleSellectButtonView.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Designsystem

struct TitleAndItemsWithSingleSelectButtonView<Item: SingeSelectButtonItemable>: View {

  // MARK: Reducer
  @Bindable
  var store: StoreOf<TitleAndItemsWithSingleSelectButton<Item>>
  init(store: StoreOf<TitleAndItemsWithSingleSelectButton<Item>>) {
    self.store = store
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .top, spacing: 16) {
      Text(store.singleSelectButtonHelper.titleText)
        .modifier(SSTypoModifier(.title_xxs))
        .frame(width: 72)

      WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
        let items = store.singleSelectButtonHelper.items
        ForEach(items) { item in
          SSButton(
            .init(
              size: .sh32,
              status: item.id == store.singleSelectButtonHelper.selectedItem?.id ? .active : .inactive,
              style: .filled,
              color: .orange,
              buttonText: item.title
            )) {
              store.send(.tappedID(item.id))
            }
        }
        
      }
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }

  var body: some View {
    ZStack {
      makeContentView()
    }
    .onAppear{
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {

  }
  
  private enum Constants {
    
  }
}
