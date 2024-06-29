//
//  InventoryBoxView.swift
//  SSRoot
//
//  Created by Kim dohyun on 5/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

// MARK: - InventoryType

public enum InventoryType: Int, CaseIterable {
  case Wedding = 0
  case FirstBirthdayDay = 1
  case Funeral = 2
  case Birthday = 3

  public var type: String {
    switch self {
    case .Wedding:
      return "결혼식"
    case .FirstBirthdayDay:
      return "돌잔치"
    case .Funeral:
      return "장례식"
    case .Birthday:
      return "생일 기념일"
    }
  }
}

// MARK: - InventoryBoxView

public struct InventoryBoxView: View {
  
  init(store: StoreOf<InventoryBox>) {
    self.store = store
  }
  
  @Bindable var store: StoreOf<InventoryBox>
  

  @ViewBuilder
  public func makeContentView() -> some View {
    ZStack {
      VStack(alignment: .leading, spacing: 8) {
        SmallBadge(property: .init(size: .small, badgeString: InventoryType.Wedding.type, badgeColor: .orange60))
          .padding([.leading, .top], 16)
        Text("나의 결혼식")
          .modifier(SSTypoModifier(.title_m))
          .lineLimit(1)
          .truncationMode(.tail)
          .foregroundColor(SSColor.gray100)
          .padding(.top, 8)
          .padding(.leading, 16)

        Text("전체 4,3350,0원")
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundColor(SSColor.gray70)
          .padding(.top, 20)
          .padding(.leading, 16)

        Text("총 164개")
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundColor(SSColor.gray50)
          .padding(.top, 4)
          .padding(.leading, 16)
      }
      .frame(width: 160, height: 160, alignment: .topLeading)
    }
    .cornerRadius(4)
    .frame(width: 160, height: 160)
    .background(SSColor.gray10)
    .padding(.leading, 16)
  }

  public var body: some View {
    makeContentView()
  }
}
