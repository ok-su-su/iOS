//
//  SSTabbar.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSTabType

public enum SSTabType: String, CaseIterable {
  case envelope
  case inventory
  case statistics
  case vote
  case mypage

  var title: String {
    switch self {
    case .envelope:
      return "보내요"
    case .inventory:
      return "받아요"
    case .statistics:
      return "통계"
    case .vote:
      return "투표"
    case .mypage:
      return "마이페이지"
    }
  }

  @ViewBuilder
  func makeImage(isEqualType: Bool) -> some View {
    if isEqualType {
      fillImage
        .resizable()
    } else {
      outlineImage
        .resizable()
    }
  }

  var outlineImage: Image {
    switch self {
    case .envelope:
      return SSImage.envelopeOutline
    case .inventory:
      return SSImage.inventoryOutline
    case .statistics:
      return SSImage.statisticsOutline
    case .vote:
      return SSImage.voteOutline
    case .mypage:
      return SSImage.mypageOutline
    }
  }

  var fillImage: Image {
    switch self {
    case .envelope:
      return SSImage.envelopeFill
    case .inventory:
      return SSImage.inventoryFill
    case .statistics:
      return SSImage.statisticsFill
    case .vote:
      return SSImage.voteFill
    case .mypage:
      return SSImage.mypageFill
    }
  }
}

// MARK: - SSTabbar

public struct SSTabbar: View {
  @Binding private var selectionType: SSTabType

  public init(selectionType: Binding<SSTabType>) {
    _selectionType = selectionType
  }

  public var body: some View {
    HStack(alignment: .center) {
      ForEach(SSTabType.allCases, id: \.self) { tabbarType in
        Button {
          selectionType = tabbarType
        } label: {
          GeometryReader { geometry in
            VStack(alignment: .center, spacing: 4) {
              selectionType
                .makeImage(isEqualType: selectionType == tabbarType)
                .frame(width: 24, height: 24, alignment: .center)

              SSText(text: tabbarType.title, designSystemFont: .title_xxxxs)
                .bold(true)
                .foregroundColor(selectionType == tabbarType ? SSColor.gray100 : SSColor.gray40)
            }.frame(width: geometry.size.width, height: geometry.size.height)
          }
        }
      }
    }
  }
}
