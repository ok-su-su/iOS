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

public enum InventoryType: String {
  case Wedding = "결혼식"
  case Funeral = "장례식"
}

public struct InventoryBoxView: View {
  
  @Bindable var inventoryBoxstore: StoreOf<InventoryBox>
  
  @ViewBuilder
  public func makeContentView() -> some View {
    ZStack {
      VStack(alignment: .leading, spacing: 8) {
        SmallBadge(property: .init(size: .small, badgeString: InventoryType.Wedding.rawValue, badgeColor: .orange60))
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
