//
//  MypageMainItemListCellView.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyPageMainItemListCellView<Item: MyPageMainItemListCellItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageMainItemListCell<Item>>

  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Text(store.property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray90)

      Spacer()

      if let subTitle = store.property.subTitle {
        Text(subTitle)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray60)
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 16)
    .background(SSColor.gray10)
    .onAppear {
      store.send(.onAppear(true))
    }
    .onTapGesture {
      store.send(.tapped)
    }
  }
}
