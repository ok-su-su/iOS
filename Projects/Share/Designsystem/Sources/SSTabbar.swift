//
//  SSTabbar.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: SSTabbarType
public enum SSTabType: String {
  case envelope
  case inventory
  case statistics
  case vote
  case mypage
}


//MARK: SSTabbar
public struct SSTabbar: View {
  @Binding private var selectionType: SSTabType

  public init(selectionType: Binding<SSTabType>) {
    self._selectionType = selectionType
  }
  
  public var body: some View {
    HStack(alignment: .center) {
      Button {
        selectionType = .envelope
      } label: {
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 4) {
            Image(uiImage: selectionType == .envelope ? SSImage.envelopeFill : SSImage.envelopeOutline)
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
            
            SSText(text: "보내요", designSystemFont: .title_xxxxs)
              .bold(true)
              .foregroundColor(selectionType == .envelope ? SSColor.gray100 : SSColor.gray40)
          }.frame(width: geometry.size.width, height: geometry.size.height)
        }
      }
      Button {
        selectionType = .inventory
      } label: {
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 4) {
            Image(uiImage: selectionType == .inventory ? SSImage.inventoryFill : SSImage.inventoryOutline)
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
            SSText(text: "받아요", designSystemFont: .title_xxxxs)
              .bold(true)
              .foregroundColor(selectionType == .inventory ? SSColor.gray100 : SSColor.gray40)
          }.frame(width: geometry.size.width, height: geometry.size.height)
        }
        
      }
      Button {
        selectionType = .statistics
      } label: {
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 4) {
            Image(uiImage: selectionType == .statistics ? SSImage.statisticsFill : SSImage.statisticsOutline)
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
            
            SSText(text: "통계", designSystemFont: .title_xxxxs)
              .bold(true)
              .foregroundColor(selectionType == .statistics ? SSColor.gray100 : SSColor.gray40)
          }.frame(width: geometry.size.width, height: geometry.size.height)
        }
      }
      Button {
        selectionType = .vote
      } label: {
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 4) {
            Image(uiImage: selectionType == .vote ? SSImage.voteFill : SSImage.voteOutline)
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
            
            SSText(text: "투표", designSystemFont: .title_xxxxs)
              .bold(true)
              .foregroundColor(selectionType == .vote ? SSColor.gray100 : SSColor.gray40)
          }.frame(width: geometry.size.width, height: geometry.size.height)
        }
      }
      Button {
        selectionType = .mypage
      } label: {
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 4) {
            Image(uiImage: selectionType == .mypage ? SSImage.mypageFill : SSImage.mypageOutline)
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
            
            SSText(text: "마이페이지", designSystemFont: .title_xxxxs)
              .bold(true)
              .foregroundColor(selectionType == .mypage ? SSColor.gray100 : SSColor.gray40)
          }.frame(width: geometry.size.width, height: geometry.size.height)
        }
      }
    }
  }
}
