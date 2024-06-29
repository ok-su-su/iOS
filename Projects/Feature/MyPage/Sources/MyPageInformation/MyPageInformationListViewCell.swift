//
//  MyPageInformationListViewCell.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyPageInformationListViewCell<Item: MyPageMainItemListCellItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageMainItemListCell<Item>>

  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Text(store.property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)

      Spacer()

      Text(store.property.subTitle ?? "미선택")
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)
    }
    .background(SSColor.gray10)
    .padding(.vertical, 12)
    .padding(.horizontal, 16)
    .onAppear {
      store.send(.onAppear(true))
    }
    .onTapGesture {
      store.send(.tapped)
    }
  }
}
