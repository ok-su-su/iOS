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

        Text(property.participantsLabelText)
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundStyle(SSColor.orange60)
      }
      Spacer()

      Text(property.createdDateText)
        .modifier(SSTypoModifier(.text_xxxs))
        .foregroundStyle(SSColor.gray50)
    }
    .frame(maxWidth: .infinity)
    
  }
}

// MARK: - ParticipantsAndDateViewProperty

struct ParticipantsAndDateViewProperty {
  private var participantsCount: Int?
  private var createdDate: Date?

  init(participantsCount: Int? = nil, createdDate: Date? = nil) {
    self.participantsCount = participantsCount
    self.createdDate = createdDate
  }

  var participantsLabelText: String {
    if let participantsCount {
      return "\(participantsCount)명 참여"
    }
    return "N명 참여"
  }

  var createdDateText: String {
    return CustomDateFormatter.stringFrom(date: createdDate ?? .now)
  }
}
