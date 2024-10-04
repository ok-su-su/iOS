//
//  ParticipantsAndDateView.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - ParticipantsAndDateView

struct ParticipantsAndDateView: View {
  var property: ParticipantsAndDateViewProperty
  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      HStack(spacing: 4) {
        SSImage
          .voteMainFill

        Text(Constants.participantsCountLabel(property.participantsCount))
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundStyle(SSColor.orange60)
      }
      Spacer()

      Text(property.createdDateLabel)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundStyle(SSColor.gray50)
    }
    .frame(maxWidth: .infinity)
  }

  enum Constants {
    static func participantsCountLabel(_ count: Int64) -> String {
      count.description + "명 참여"
    }
  }
}

// MARK: - ParticipantsAndDateViewProperty

struct ParticipantsAndDateViewProperty {
  let participantsCount: Int64
  let createdDateLabel: String

  init(participantsCount: Int64?, createdDateLabel: String?) {
    self.participantsCount = participantsCount ?? 0
    self.createdDateLabel = createdDateLabel ?? ""
  }
}
