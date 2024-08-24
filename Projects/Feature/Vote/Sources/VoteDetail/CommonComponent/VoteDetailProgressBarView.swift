//
//  VoteDetailProgressBarView.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - VoteDetailProgressProperty

struct VoteDetailProgressProperty: Equatable {
  var isShowProgressBar: Bool = false
  private var _items: [VoteDetailProgressBarProperty]
  var items: [VoteDetailProgressBarProperty] { _items }
  private var _currentVotedItemID: Int64? = nil
  var currentVotedItemID: Int64? { _currentVotedItemID }

  mutating func updateCurrentVoteItemID(_ id: Int64) {
    _currentVotedItemID = id
  }

  mutating func updateItems(_ items: [VoteDetailProgressBarProperty]) {
    let totalCount = items.reduce(0) { $0 + $1.count }
    _items = items.map { property in
      var mutableProperty = property
      mutableProperty.updateTotalCount(totalCount)
      return mutableProperty
    }
  }

  init(isShowProgressBar: Bool, items: [VoteDetailProgressBarProperty]) {
    self.isShowProgressBar = isShowProgressBar
    _items = items
  }
}

// MARK: - VoteDetailProgressBarProperty

struct VoteDetailProgressBarProperty: Equatable, Identifiable {
  /// id
  var id: Int64
  /// 순서
  var seq: Int
  /// 이름
  var title: String
  /// 퍼센테이지
  var percentageLabel: Int {
    Int(portion * 100)
  }

  var portion: Double {
    Double(count) / Double(totalVoteCount)
  }

  /// 참여한 사람의 수
  var count: Int64

  private var totalVoteCount: Int64 = 30

  mutating func updateTotalCount(_ count: Int64) {
    totalVoteCount = count
  }

  init(id: Int64, seq: Int, title: String, count: Int64, totalVoteCount: Int64 = 30) {
    self.id = id
    self.seq = seq
    self.title = title
    self.count = count
    self.totalVoteCount = totalVoteCount
  }
}

// MARK: - VoteDetailProgressView

struct VoteDetailProgressView: View {
  var property: VoteDetailProgressProperty
  init(property: VoteDetailProgressProperty, onTapProgressBarClosure: @escaping (Int64) -> Void) {
    self.property = property
    onTapProgressBar = onTapProgressBarClosure
  }

  let onTapProgressBar: (Int64) -> Void

  @ViewBuilder
  private func makeProgressBarView(_ item: VoteDetailProgressBarProperty) -> some View {
    ZStack(alignment: .leading) {
      // progress bar
      if property.isShowProgressBar {
        GeometryReader { proxy in
          SSColor.orange40
            .frame(width: proxy.size.width * item.portion, alignment: .leading)
        }
      }

      HStack(alignment: .center, spacing: 0) {
        let isSelected = property.currentVotedItemID == item.id
        // if voted, add check image
        if isSelected {
          SSImage
            .commonCheckBox
            .resizable()
            .frame(width: 20, height: 20)
        }

        Text(item.title)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        // if show Progress
        if property.isShowProgressBar {
          HStack(spacing: 8) {
            Text(Constants.participantsCountLabel(item.count))
              .modifier(SSTypoModifier(.text_xxxs))
              .foregroundStyle(SSColor.gray70)

            Text(Constants.percentageLabel(item.percentageLabel))
              .modifier(SSTypoModifier(.title_xxs))
              .foregroundStyle(SSColor.gray100)
          }
        }
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
    .background(SSColor.orange10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .onTapGesture {
      onTapProgressBar(item.id)
    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      ForEach(property.items) { item in
        makeProgressBarView(item)
      }
    }
  }

  enum Constants {
    static var percentageLabel: (_ val: Int) -> String = { val in
      return val.description + "%"
    }

    static var participantsCountLabel: (_ val: Int64) -> String = { val in
      return val.description + "명"
    }
  }
}
